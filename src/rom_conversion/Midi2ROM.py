#!/usr/bin/env python3
import getopt, sys, os
from mido import MidiFile
from collections import OrderedDict

def outputVerilog(mid, outputparampath, track_idx, name_suffix, track_parameters):
	address = 0
	nb = track_parameters["delay_nbit"] + track_parameters["note_nbit"] + 1
	with open(os.path.join(outputparampath, "ROM_notes_%s.v" % (name_suffix, )), "w") as file:
		print("""module notes_sequence_%s(
	input clk,
	input [%d:0] address,
	output reg [%d:0] note,
	output reg note_on,
	output reg [%d:0] delay
);

reg [%d:0] note_;

always @(posedge clk) begin
case(address)""" % (name_suffix, track_parameters["messages_address_bits"] - 1, track_parameters["note_nbit"] - 1, track_parameters["delay_nbit"] - 1, nb - 1), file=file)
		
		for msg in mid.tracks[track_idx]:
			if msg.type in ('note_on', 'note_off'):
				print("%d:note_<=%s'b%s%s;" % (address, nb, ('{0:0' + str(track_parameters["note_nbit"] + 1) +'b}').format((msg.note - track_parameters["note_min"]) | (1<<(track_parameters["note_nbit"]) if msg.type == 'note_on' and msg.velocity > 0 else 0)), ('{0:0' + str(track_parameters["delay_nbit"]) + 'b}').format(msg.time - track_parameters["delay_min"])), file=file)
				#print("%s, %s, %s" % (address, msg.note, msg.time))
				address += 1

		print("default: note_ <= %d'b0;" % (nb,), file=file)
		print("""endcase

note_on <= note_[%d:%d];
note <= note_[%d:%d];
delay <= note_[%d:0];
end
endmodule
""" % (nb - 1, nb - 1, nb - 2, track_parameters["delay_nbit"], track_parameters["delay_nbit"] - 1), file=file)
		print("", file=file)


def outputQuartus(mid, outputparampath, track_idx, name_suffix, track_parameters):
	address = 0
	nb = track_parameters["delay_nbit"] + track_parameters["note_nbit"] + 1
	with open(os.path.join(outputparampath, "ROM_notes_%s.mif" % (name_suffix, )), "w") as file:
		print("WIDTH = %s;" % (nb, ), file=file)
		#print("DEPTH = %s;" % (2**int.bit_length(len(mid.tracks[track_idx]) - 1)), file=file)
		print("DEPTH = %s;" % (track_parameters["messages_len"]), file=file)
		print("ADDRESS_RADIX = HEX;", file=file)
		print("DATA_RADIX = BIN;", file=file)
		print("CONTENT BEGIN", file=file)

		for msg in mid.tracks[track_idx]:
			if msg.type in ('note_on', 'note_off'):
				addressstring = '{0:x}'.format(address)
				rstring = gstring = bstring = ""
				print("%s: %s%s;" % (addressstring, ('{0:0' + str(track_parameters["note_nbit"] + 1) +'b}').format((msg.note - track_parameters["note_min"]) | (1<<(track_parameters["note_nbit"]) if msg.type == 'note_on' and msg.velocity > 0 else 0)), ('{0:0' + str(track_parameters["delay_nbit"]) + 'b}').format(msg.time - track_parameters["delay_min"])), file=file)
				address += 1

		print("END;", file=file)
		print("", file=file)


def track_parameters(track, ticks_per_beat, outputpath, rom_index, name_suffix):
	retval = OrderedDict()

	messages = 0
	note_min = 256
	note_max = 0
	delay_min = 10**10
	delay_max = 0
	for msg in track:
		if msg.type in ('note_on', 'note_off'):
			messages += 1
			if msg.note < note_min:
				note_min = msg.note
			if msg.note > note_max:
				note_max = msg.note
			if msg.time < delay_min:
				delay_min = msg.time
			if msg.time > delay_max:
				delay_max = msg.time

	retval["messages_len"] = messages
	retval["note_min"] = note_min
	retval["note_max"] = note_max
	retval["delay_min"] = 0 #delay_min
	retval["delay_max"] = delay_max

	retval["messages_address_bits"] = int.bit_length(messages - 1)
	retval["note_nbit"] = int.bit_length(note_max - note_min)
	retval["delay_nbit"] = int.bit_length(delay_max - delay_min)

	if messages != 0:
		with open(os.path.join(outputpath, "Parameters_ROM_%s.vh" % (name_suffix, )), "w") as file:
			for k,v in retval.items():
				print("parameter ROM_%s_%s=%s;" % (rom_index, k, v), file=file)

			print("", file=file)

	retval["empty_track"] = True if messages == 0 else False

	return retval


def usage():
	print("""usage: %s [-h|-i|-o|-p|-f|-b|-t]
		-h: help
		-i: midi input file
		-o: output ROM path
		-p: output parameters path
		-f: output file format ("verilog"|"quartus" mif)
		-b: BPM (120, 240, ...)
		-t: tracks (0,1 or 1,3,6, ...)
		-n: ROMs naming mode: 0 -> as tracks index extracted, 1 -> squentially from 0
		-r: ROMs naming prefix: default -> nothing or string
		""" % sys.argv[0])


def main():
	try:
		opts, args = getopt.getopt(sys.argv[1:], 'hi:o:p:f:b:t:n:r:', ['help', 'input-file=', 'output-ROM-path=', 'output-parameter-path=', 'output-format=verilog', 'bpm=240', 'output-tracks=', 'ROM-numbering=1', 'ROM-naming-prefix='])
	except getopt.GetoptError as err:
		# print help information and exit:
		print(err) # will print something like "option -a not recognized"
		usage()
		sys.exit(2)

	inputfile = None
	outputROMpath = None
	outputparampath = None
	outputformat = "verilog"
	bpm = 240
	tracks = None
	numbering = 1
	naming_prefix = None
	abs_max_delay_ticks = 0
	abs_min_delay_ticks = 10**10
	abs_max_note_bits = 0
	abs_max_address_bits = 0
	abs_max_delay_bits = 0

	for o, a in opts:
		if o in ("-h", "--help"):
			usage()
			sys.exit()
		elif o in ("-i", "--input-file"):
			inputfile = a
		elif o in ("-o", "--output-ROM-path"):
			outputROMpath = a
		elif o in ("-p", "--output-parameter-path"):
			outputparampath = a
		elif o in ("-f", "--output-format"):
			outputformat = a
		elif o in ("-b", "--bpm"):
			bpm = int(a)
		elif o in ("-t", "--output-tracks"):
			tracks = a.split(',');
		elif o in ("-n", "--ROM-numbering"):
			numbering = int(a)
		elif o in ("-r", "--ROM-naming-prefix"):
			naming_prefix = a
		else:
			assert False, "unhandled option"

	if inputfile is None or outputROMpath is None or outputROMpath is None:
		usage()
		sys.exit(2)

	print("Input file: %s" % (inputfile))
	print("Output ROM path: %s" % (outputROMpath))
	print("Output Parameters path: %s" % (outputparampath))
	print("Output format: %s" % ("Verilog" if outputformat == "verilog" else "Quartus MIF"))
	print("Tracks to extract: %s" % (tracks if tracks is not None else 'ALL'))
	print("ROMs numbering mode: %s" % ('as tracks index extracted' if numbering == 0 else 'squentially from 0'))
	print("ROMs naming prefix: %s" % (naming_prefix if naming_prefix is not None else '[nothing]'))

	mid = MidiFile(inputfile)

	#mido.merge_tracks(tracks)
	
	tracks_parameters = {}
	k = 0
	for (i, track) in enumerate(mid.tracks):
		if tracks is None or str(i) in tracks:
			index = str(i) if numbering == 0 else str(k)
			name_prefix = ('%s_' % (naming_prefix,) if naming_prefix is not None else '') + index
			p = track_parameters(track, mid.ticks_per_beat, outputparampath, index, name_prefix)
			if not p["empty_track"]:

				if p["delay_max"] > abs_max_delay_ticks:
					abs_max_delay_ticks = p["delay_max"]

				if p["delay_min"] < abs_min_delay_ticks:
					abs_min_delay_ticks = p["delay_min"]

				if p["note_nbit"] > abs_max_note_bits:
					abs_max_note_bits = p["note_nbit"]

				if p["messages_address_bits"] > abs_max_address_bits:
					abs_max_address_bits = p["messages_address_bits"]

				if p["delay_nbit"] > abs_max_delay_bits:
					abs_max_delay_bits = p["delay_nbit"]

				tracks_parameters[i] = p
				if outputformat == "verilog":
					outputVerilog(mid, outputROMpath, i, name_prefix, p)
				elif outputformat == "quartus":
					outputQuartus(mid, outputROMpath, i, name_prefix, p)
				k += 1

	name_prefix = '%s_' % (naming_prefix,) if naming_prefix is not None else ''
	with open(os.path.join(outputparampath, "Parameters_%sgeneral.vh" % (name_prefix,)), "w") as file:
		print("parameter ROMS_number=%d;" % (len(tracks_parameters), ), file=file)
		print("parameter note_max_bits=%d;" % (abs_max_note_bits, ), file=file)
		print("parameter address_max_bits=%d;" % (abs_max_address_bits, ), file=file)
		print("parameter delay_max_bits=%d;" % (abs_max_delay_bits, ), file=file)
		tpb = mid.ticks_per_beat
		print("parameter ticks_per_beat=%d;" % (tpb, ), file=file)
		print("parameter BPM=%d;" % (bpm,), file=file)
		bps = bpm/60.0
		print("parameter BPS=%s;" % (bps,), file=file)
		ticks_hz = round(bps * mid.ticks_per_beat)
		print("parameter ticks_hz=%d;" % (ticks_hz, ), file=file)
		delay_clock_per_tick = 1000
		print("parameter delay_clocks_per_tick=%d;" % (delay_clock_per_tick, ), file=file)
		delay_clock_per_hz = round(ticks_hz * delay_clock_per_tick)
		print("parameter delay_clock_hz=%d;" % (delay_clock_per_hz, ), file=file)
		print("parameter delay_reg_bits=%d;" % (int.bit_length(round(delay_clock_per_hz * abs_max_delay_ticks)), ), file=file)

		print("", file=file)

if __name__ == "__main__":
	print(">----------------")
	main()
	print("<----------------")


#!/usr/bin/env python3
import getopt, sys
import png

def inputVerilog(writer, outputfile, inputfile, rb, gb, bb, width, height, address_bits, mimic_default_value, default_value):
	nline = 1
	nb = rb + gb + bb
	outputarray = []
	outputdict = {}
	currentaddress = None
	with open(outputfile, "wb") as ofile:
		with open(inputfile, "r") as ifile:
			for line in ifile:
				cleanline = line.strip()
				if not cleanline:
					continue

				parts = cleanline.split(":")
				if len(parts) == 2:
					addressdatastr = parts[0].strip()
					addressparts = addressdatastr.split("'")
					if len(addressparts) == 2:
						if not addressparts[0] == str(address_bits):
							print("Expecting %s address bits, found %s at line %s, exiting" % (address_bits, addressparts[0], nline))
							sys.exit(3)
						addressdata = addressparts[1][1 : address_bits + 1]
						currentaddress = int(addressdata, 2)

				parts = cleanline.split("=")
				if len(parts) == 2:
					rgbdatastr = parts[1].strip()
					rgbparts = rgbdatastr.split("'")
					if len(rgbparts) == 2:
						if nb != int(rgbparts[0]):
							print("Expecting %s data bits, found %s at line %s, exiting" % (nb, int(rgbparts[0]), nline))
							sys.exit(3)
						if not rgbparts[1].startswith('b'):
							print("Data bits at line %s is not in binary format, exiting" % (nline,))
							sys.exit(3)
						if not rgbparts[1].endswith(';'):
							print("Data bits at line %s does not end with ';', exiting" % (nline,))
							sys.exit(3)
						rgbdata = rgbparts[1][1 : nb + 1]
						r = g = b = 0
						if rb > 0:
							r = (int(rgbdata[0 : rb], 2) << (8 - rb)) & 0xFF
						if gb > 0:
							g = (int(rgbdata[rb : rb + gb], 2) << (8 - gb)) & 0xFF
						if bb > 0:
							b = (int(rgbdata[rb + gb : rb + gb + bb], 2) << (8 - bb)) & 0xFF
						#outputarray.extend([r, g, b])
						#outputarray.insert(currentaddress * 3, r)
						#outputarray.insert(currentaddress * 3 + 1, g)
						#outputarray.insert(currentaddress * 3 + 2, b)
						outputdict[currentaddress] = [r, g, b]
				nline += 1

		rd, gd, bd = default_value.split('_')
		for i in range(0, 2**address_bits):
			if i in outputdict.keys():
				outputarray.insert(i * 3, outputdict[i][0])
				outputarray.insert(i * 3 + 1, outputdict[i][1])
				outputarray.insert(i * 3 + 2, outputdict[i][2])
			elif mimic_default_value:
				outputarray.insert(i * 3, int(rd) & 0xFF)
				outputarray.insert(i * 3 + 1, int(gd) & 0xFF)
				outputarray.insert(i * 3 + 2, int(bd) & 0xFF)
			
		writer.write_array(ofile, outputarray)


def inputQuartus(p, address_bits, outputfile, rb, gb, bb):
	pass


def usage():
	print("""usage: %s [-h|-i|-o|-f|-b|-x|-y]
		-h: help
		-i: input file
		-o: output png file
		-f: input file format ("verilog"|"quartus" mif)
		-b: input bit format (for example 444)
		-x: image width
		-y: image height
		-q: mimic rom default value
		-d: default value (for example 32_118_255 equals R32 G118 B255)
""" % sys.argv[0])


def main():
	try:
		opts, args = getopt.getopt(sys.argv[1:], 'hi:o:f:b:x:y:qd:', ['help', 'input-file=', 'output-file=', 'input-format=verilog', 'input-bit-format=444', 'width=', 'height=', 'default_value=0_0_0', 'mimic_default_value'])
	except getopt.GetoptError as err:
		# print help information and exit:
		print(err) # will print something like "option -a not recognized"
		usage()
		sys.exit(2)

	inputfile = None
	outputfile = None
	inputformat = "verilog"
	rb = 4
	gb = 4
	bb = 4
	width = 0
	height = 0
	mimic_default_value = False
	default_value = "0_0_0"

	for o, a in opts:
		if o in ("-h", "--help"):
			usage()
			sys.exit()
		elif o in ("-i", "--input-file"):
			inputfile = a
		elif o in ("-o", "--output-file"):
			outputfile = a
		elif o in ("-f", "--input-format"):
			inputformat = a
		elif o in ("-b", "--input-bit-format"):
			if len(a) != 3:
				usage()
				sys.exit(2)
			rb = int(a[0])
			gb = int(a[1])
			bb = int(a[2])
		elif o in ("-x", "--width"):
			width = int(a)
		elif o in ("-y", "--height"):
			height = int(a)
		elif o in ("-q", "--mimic_default_value"):
			mimic_default_value = True
		elif o in ("-d", "--default_value"):
			default_value = int(a)
		else:
			assert False, "unhandled option"

	if inputfile is None or outputfile is None:
		usage()
		sys.exit(2)

	if width <= 0 or height <= 0:
		print("Invalid image size W%s, H%s" % (width, height))
		usage()
		sys.exit(2)

	print("Input file: %s" % (inputfile))
	print("Output file: %s" % (outputfile))
	print("Input format: %s" % (inputformat))
	print("Input bit format: R%s, G%s, B%s" % (rb, gb, bb))
	print("Input ROM size: W%s, H%s" % (width, height))

	address_bits = int.bit_length(width - 1) + int.bit_length(height - 1)

	writer = png.Writer(width=width, height=height, alpha=False, compression=9, bitdepth=8)
	if inputformat == "verilog":
		inputVerilog(writer, outputfile, inputfile, rb, gb, bb, width, height, address_bits, mimic_default_value, default_value)
	#elif inputformat == "quartus":
	#	inputQuartus(writer, address_bits, outputfile, rb, gb, bb)

if __name__ == "__main__":
	print(">----------------")
	main()
	print("<----------------")


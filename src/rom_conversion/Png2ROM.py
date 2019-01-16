#!/usr/bin/env python3
import getopt, sys
import png

def outputVerilog(p, address_bits_w, address_bits_h, outputfile, rb, gb, bb, w, h, rcorganization):
	address_bits = address_bits_w + address_bits_h
	address = 0
	row = 0
	col = 0
	nb = rb + gb + bb
	with open(outputfile, "w") as file:
		print("//.....", file=file)
		
		for pr in p:
			for i in range(0, len(pr), 3):
				r = pr[i]
				g = pr[i+1]
				b = pr[i+2]
				if not rcorganization:
					addressstring = ('{0:0'+str(address_bits)+'b}').format(address)
				else:
					addressstring = "%s%s" % (('{0:0'+str(address_bits_h)+'b}').format(row), ('{0:0'+str(address_bits_w)+'b}').format(col))
				rstring = gstring = bstring = ""
				if rb > 0:
					rstring = ('{0:0'+str(rb)+'b}').format(r>>(8-rb)&0xFF)
				if gb > 0:
					gstring = ('{0:0'+str(gb)+'b}').format(g>>(8-gb)&0xFF)
				if bb > 0:
					bstring = ('{0:0'+str(bb)+'b}').format(b>>(8-bb)&0xFF)
				print("%d'b%s: color_data = %d'b%s%s%s;" % (address_bits, addressstring, nb, rstring, gstring, bstring), file=file)
				address += 1
				if col >= w - 1:
					col = 0
					row += 1
				else:
					col +=1

		print("//.....", file=file)
		print("", file=file)


def outputQuartus(p, address_bits_w, address_bits_h, outputfile, rb, gb, bb, w, h, rcorganization):
	address_bits = address_bits_w + address_bits_h
	address = 0
	row = 0
	col = 0
	nb = rb + gb + bb
	with open(outputfile, "w") as file:
		print("WIDTH = %s;" % (nb, ), file=file)
		#print("DEPTH = %s;" % (w * h), file=file)
		print("DEPTH = %s;" % (2**address_bits), file=file)
		print("ADDRESS_RADIX = HEX;", file=file)
		print("DATA_RADIX = BIN;", file=file)
		print("CONTENT BEGIN", file=file)

		for pr in p:
			for i in range(0, len(pr), 3):
				r = pr[i]
				g = pr[i+1]
				b = pr[i+2]
				if not rcorganization:
					addressstring = '{0:x}'.format(address)
				else:
					addressstring = '{0:x}'.format((row<<address_bits_w) + col)
				rstring = gstring = bstring = ""
				if rb > 0:
					rstring = ('{0:0'+str(rb)+'b}').format(r>>(8-rb)&0xFF)
				if gb > 0:
					gstring = ('{0:0'+str(gb)+'b}').format(g>>(8-gb)&0xFF)
				if bb > 0:
					bstring = ('{0:0'+str(bb)+'b}').format(b>>(8-bb)&0xFF)
				print("%s: %s%s%s;" % (addressstring, rstring, gstring, bstring), file=file)
				address += 1
				#print(row, col)
				if col >= w - 1:
					col = 0
					row += 1
				else:
					col +=1

		print("END;", file=file)
		print("", file=file)


def usage():
	print("""usage: %s [-h|-i|-o|-f|-b]
		-h: help
		-i: png input file
		-o: output file
		-f: output file format ("verilog"|"quartus" mif)
		-b: output bit format (for example 444)
		-k: keep row/column organization""" % sys.argv[0])


def main():
	try:
		opts, args = getopt.getopt(sys.argv[1:], 'hi:o:f:b:k', ['help', 'input-file=', 'output-file=', 'output-format=verilog', 'output-bit-format=444', 'row-col-organization'])
	except getopt.GetoptError as err:
		# print help information and exit:
		print(err) # will print something like "option -a not recognized"
		usage()
		sys.exit(2)

	inputfile = None
	outputfile = None
	outputformat = "verilog"
	rcorganization = False
	rb = 4
	gb = 4
	bb = 4

	for o, a in opts:
		if o in ("-h", "--help"):
			usage()
			sys.exit()
		elif o in ("-i", "--input-file"):
			inputfile = a
		elif o in ("-o", "--output-file"):
			outputfile = a
		elif o in ("-f", "--output-format"):
			outputformat = a
		elif o in ("-b", "--output-bit-format"):
			if len(a) != 3:
				usage()
				sys.exit(2)
			rb = int(a[0])
			gb = int(a[1])
			bb = int(a[2])
		elif o in ("-k", "--row-col-organization"):
			rcorganization = True
		else:
			assert False, "unhandled option"

	if inputfile is None or outputfile is None:
		usage()
		sys.exit(2)

	print("Input file: %s" % (inputfile))
	print("Output file: %s" % (outputfile))
	print("Output format: %s" % (outputformat))
	print("Output bit format: R%s, G%s, B%s" % (rb, gb, bb))
	print("Keep row/col organization: %s" % rcorganization)

	r = png.Reader(inputfile)
	w, h, p, m = r.asRGB()
	address_bits_w = int.bit_length(w - 1)
	address_bits_h = int.bit_length(h - 1)

	if outputformat == "verilog":
		outputVerilog(p, address_bits_w, address_bits_h, outputfile, rb, gb, bb, w, h, rcorganization)
	elif outputformat == "quartus":
		outputQuartus(p, address_bits_w, address_bits_h, outputfile, rb, gb, bb, w, h, rcorganization)

if __name__ == "__main__":
	print(">----------------")
	main()
	print("<----------------")


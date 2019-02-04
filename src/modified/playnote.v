// Monophonic

/////////////////////////////////////////////////////
module playnote(
	input clk,
	input wire [6:0] note,
	input out_enable,
	output reg speaker
);

//108 notes
//Note		Frequency (Hz)
//C0			16.35
//C#0/Db0	17.32
//D0			18.35
//D#0/Eb0	19.45
//E0			20.60
//F0			21.83
//F#0/Gb0	23.12
//G0			24.50
//G#0/Ab0	25.96
//A0			27.50
//A#0/Bb0	29.14
//B0			30.87
//C1			32.70
//C#1/Db1	34.65
//D1			36.71
//D#1/Eb1	38.89
//E1			41.20
//F1			43.65
//F#1/Gb1	46.25
//G1			49.00
//G#1/Ab1	51.91
//A1			55.00
//A#1/Bb1	58.27
//B1			61.74
//C2			65.41
//C#2/Db2	69.30
//D2			73.42
//D#2/Eb2	77.78
//E2			82.41
//F2			87.31
//F#2/Gb2	92.50
//G2			98.00
//G#2/Ab2	103.83
//A2			110.00
//A#2/Bb2	116.54
//B2			123.47
//C3			130.81
//C#3/Db3	138.59
//D3			146.83
//D#3/Eb3	155.56
//E3			164.81
//F3			174.61
//F#3/Gb3	185.00
//G3			196.00
//G#3/Ab3	207.65
//A3			220.00
//A#3/Bb3	233.08
//B3			246.94
//C4			261.63
//C#4/Db4	277.18
//D4			293.66
//D#4/Eb4	311.13
//E4			329.63
//F4			349.23
//F#4/Gb4	369.99
//G4			392.00
//G#4/Ab4	415.30
//A4			440.00
//A#4/Bb4	466.16
//B4			493.88
//C5			523.25
//C#5/Db5	554.37
//D5			587.33
//D#5/Eb5	622.25
//E5			659.25
//F5			698.46
//F#5/Gb5	739.99
//G5			783.99
//G#5/Ab5	830.61
//A5			880.00
//A#5/Bb5	932.33
//B5			987.77
//C6			1046.50
//C#6/Db6	1108.73
//D6			1174.66
//D#6/Eb6	1244.51
//E6			1318.51
//F6			1396.91
//F#6/Gb6	1479.98
//G6			1567.98
//G#6/Ab6	1661.22
//A6			1760.00
//A#6/Bb6	1864.66
//B6			1975.53
//C7			2093.00
//C#7/Db7	2217.46
//D7			2349.32
//D#7/Eb7	2489.02
//E7			2637.02
//F7			2793.83
//F#7/Gb7	2959.96
//G7			3135.96
//G#7/Ab7	3322.44
//A7			3520.00
//A#7/Bb7	3729.31
//B7			3951.07
//C8			4186.01
//C#8/Db8	4434.92
//D8			4698.63
//D#8/Eb8	4978.03
//E8			5274.04
//F8			5587.65
//F#8/Gb8	5919.91
//G8			6271.93
//G#8/Ab8	6644.88
//A8			7040.00
//A#8/Bb8	7458.62
//B8			7902.13

localparam base_clock_frequency = 10000000; //10 Mhz
localparam C0_divider = base_clock_frequency			/ 16.35 / 2 - 1;//C0		
localparam Cd0_Db0_divider = base_clock_frequency	/ 17.32 / 2 - 1;//  C#0/Db0
localparam D0_divider = base_clock_frequency			/ 18.35 / 2 - 1;//  D0		
localparam Dd0_Eb0_divider = base_clock_frequency	/ 19.45 / 2 - 1;//  D#0/Eb0
localparam E0_divider = base_clock_frequency			/ 20.60 / 2 - 1;//  E0		
localparam F0_divider = base_clock_frequency			/ 21.83 / 2 - 1;//  F0		
localparam Fd0_Gb0_divider = base_clock_frequency	/ 23.12 / 2 - 1;//  F#0/Gb0
localparam G0_divider = base_clock_frequency			/ 24.50 / 2 - 1;//  G0		
localparam Gd0_Ab0_divider = base_clock_frequency	/ 25.96 / 2 - 1;//  G#0/Ab0
localparam A0_divider = base_clock_frequency			/ 27.50 / 2 - 1;//  A0		
localparam Ad0_Bb0_divider = base_clock_frequency	/ 29.14 / 2 - 1;//  A#0/Bb0
localparam B0_divider = base_clock_frequency			/ 30.87 / 2 - 1;//  B0		
localparam C1_divider = base_clock_frequency			/ 32.70 / 2 - 1;//  C1		
localparam Cd1_Db1_divider = base_clock_frequency	/ 34.65 / 2 - 1;//  C#1/Db1
localparam D1_divider = base_clock_frequency			/ 36.71 / 2 - 1;//  D1		
localparam Dd1_Eb1_divider = base_clock_frequency	/ 38.89 / 2 - 1;//  D#1/Eb1
localparam E1_divider = base_clock_frequency			/ 41.20 / 2 - 1;//  E1		
localparam F1_divider = base_clock_frequency			/ 43.65 / 2 - 1;//  F1		
localparam Fd1_Gb1_divider = base_clock_frequency	/ 46.25 / 2 - 1;//  F#1/Gb1
localparam G1_divider = base_clock_frequency			/ 49.00 / 2 - 1;//  G1		
localparam Gd1_Ab1_divider = base_clock_frequency	/ 51.91 / 2 - 1;//  G#1/Ab1
localparam A1_divider = base_clock_frequency			/ 55.00 / 2 - 1;//  A1		
localparam Ad1_Bb1_divider = base_clock_frequency	/ 58.27 / 2 - 1;//  A#1/Bb1
localparam B1_divider = base_clock_frequency			/ 61.74 / 2 - 1;//  B1		
localparam C2_divider = base_clock_frequency			/ 65.41 / 2 - 1;// C2		
localparam Cd2_Db2_divider = base_clock_frequency	/ 69.30 / 2 - 1;//  C#2/Db2
localparam D2_divider = base_clock_frequency			/ 73.42 / 2 - 1;//  D2		
localparam Dd2_Eb2_divider = base_clock_frequency	/ 77.78 / 2 - 1;//  D#2/Eb2
localparam E2_divider = base_clock_frequency			/ 82.41 / 2 - 1;//  E2		
localparam F2_divider = base_clock_frequency			/ 87.31 / 2 - 1;//  F2		
localparam Fd2_Gb2_divider = base_clock_frequency	/ 92.50 / 2 - 1;//  F#2/Gb2
localparam G2_divider = base_clock_frequency			/ 98.00 / 2 - 1;//  G2		
localparam Gd2_Ab2_divider = base_clock_frequency	/ 103.83 / 2 - 1;// G#2/Ab2
localparam A2_divider = base_clock_frequency			/ 110.00 / 2 - 1;// A2		
localparam Ad2_Bb2_divider = base_clock_frequency	/ 116.54 / 2 - 1;// A#2/Bb2
localparam B2_divider = base_clock_frequency			/ 123.47 / 2 - 1;// B2		
localparam C3_divider = base_clock_frequency			/ 130.81 / 2 - 1;// C3		
localparam Cd3_Db3_divider = base_clock_frequency	/ 138.59 / 2 - 1;// C#3/Db3
localparam D3_divider = base_clock_frequency			/ 146.83 / 2 - 1;// D3		
localparam Dd3_Eb3_divider = base_clock_frequency	/ 155.56 / 2 - 1;// D#3/Eb3
localparam E3_divider = base_clock_frequency			/ 164.81 / 2 - 1;// E3		
localparam F3_divider = base_clock_frequency			/ 174.61 / 2 - 1;// F3		
localparam Fd3_Gb3_divider = base_clock_frequency	/ 185.00 / 2 - 1;// F#3/Gb3
localparam G3_divider = base_clock_frequency			/ 196.00 / 2 - 1;// G3		
localparam Gd3_Ab3_divider = base_clock_frequency	/ 207.65 / 2 - 1;// G#3/Ab3
localparam A3_divider = base_clock_frequency			/ 220.00 / 2 - 1;// A3		
localparam Ad3_Bb3_divider = base_clock_frequency	/ 233.08 / 2 - 1;// A#3/Bb3
localparam B3_divider = base_clock_frequency			/ 246.94 / 2 - 1;// B3		
localparam C4_divider = base_clock_frequency			/ 261.63 / 2 - 1;// C4		
localparam Cd4_Db4_divider = base_clock_frequency	/ 277.18 / 2 - 1;// C#4/Db4
localparam D4_divider = base_clock_frequency			/ 293.66 / 2 - 1;// D4		
localparam Dd4_Eb4_divider = base_clock_frequency	/ 311.13 / 2 - 1;// D#4/Eb4
localparam E4_divider = base_clock_frequency			/ 329.63 / 2 - 1;// E4		
localparam F4_divider = base_clock_frequency			/ 349.23 / 2 - 1;// F4		
localparam Fd4_Gb4_divider = base_clock_frequency	/ 369.99 / 2 - 1;// F#4/Gb4
localparam G4_divider = base_clock_frequency			/ 392.00 / 2 - 1;// G4		
localparam Gd4_Ab4_divider = base_clock_frequency	/ 415.30 / 2 - 1;// G#4/Ab4
localparam A4_divider = base_clock_frequency			/ 440.00 / 2 - 1;// A4		
localparam Ad4_Bb4_divider = base_clock_frequency	/ 466.16 / 2 - 1;// A#4/Bb4
localparam B4_divider = base_clock_frequency			/ 493.88 / 2 - 1;// B4		
localparam C5_divider = base_clock_frequency			/ 523.25 / 2 - 1;// C5		
localparam Cd5_Db5_divider = base_clock_frequency	/ 554.37 / 2 - 1;// C#5/Db5
localparam D5_divider = base_clock_frequency			/ 587.33 / 2 - 1;// D5		
localparam Dd5_Eb5_divider = base_clock_frequency	/ 622.25 / 2 - 1;// D#5/Eb5
localparam E5_divider = base_clock_frequency			/ 659.25 / 2 - 1;// E5		
localparam F5_divider = base_clock_frequency			/ 698.46 / 2 - 1;// F5		
localparam Fd5_Gb5_divider = base_clock_frequency	/ 739.99 / 2 - 1;// F#5/Gb5
localparam G5_divider = base_clock_frequency			/ 783.99 / 2 - 1;// G5		
localparam Gd5_Ab5_divider = base_clock_frequency	/ 830.61 / 2 - 1;// G#5/Ab5
localparam A5_divider = base_clock_frequency			/ 880.00 / 2 - 1;// A5		
localparam Ad5_Bb5_divider = base_clock_frequency	/ 932.33 / 2 - 1;// A#5/Bb5
localparam B5_divider = base_clock_frequency			/ 987.77 / 2 - 1;// B5		
localparam C6_divider = base_clock_frequency			/ 1046.50 / 2 - 1;// C6		
localparam Cd6_Db6_divider = base_clock_frequency	/ 1108.73 / 2 - 1;// C#6/Db6
localparam D6_divider = base_clock_frequency			/ 1174.66 / 2 - 1;// D6		
localparam Dd6_Eb6_divider = base_clock_frequency	/ 1244.51 / 2 - 1;// D#6/Eb6
localparam E6_divider = base_clock_frequency			/ 1318.51 / 2 - 1;// E6		
localparam F6_divider = base_clock_frequency			/ 1396.91 / 2 - 1;// F6		
localparam Fd6_Gb6_divider = base_clock_frequency	/ 1479.98 / 2 - 1;// F#6/Gb6
localparam G6_divider = base_clock_frequency			/ 1567.98 / 2 - 1;// G6		
localparam Gd6_Ab6_divider = base_clock_frequency	/ 1661.22 / 2 - 1;// G#6/Ab6
localparam A6_divider = base_clock_frequency			/ 1760.00 / 2 - 1;// A6		
localparam Ad6_Bb6_divider = base_clock_frequency	/ 1864.66 / 2 - 1;// A#6/Bb6
localparam B6_divider = base_clock_frequency			/ 1975.53 / 2 - 1;// B6		
localparam C7_divider = base_clock_frequency			/ 2093.00 / 2 - 1;// C7		
localparam Cd7_Db7_divider = base_clock_frequency	/ 2217.46 / 2 - 1;// C#7/Db7
localparam D7_divider = base_clock_frequency			/ 2349.32 / 2 - 1;// D7		
localparam Dd7_Eb7_divider = base_clock_frequency	/ 2489.02 / 2 - 1;// D#7/Eb7
localparam E7_divider = base_clock_frequency			/ 2637.02 / 2 - 1;// E7		
localparam F7_divider = base_clock_frequency			/ 2793.83 / 2 - 1;// F7		
localparam Fd7_Gb7_divider = base_clock_frequency	/ 2959.96 / 2 - 1;// F#7/Gb7
localparam G7_divider = base_clock_frequency			/ 3135.96 / 2 - 1;// G7		
localparam Gd7_Ab7_divider = base_clock_frequency	/ 3322.44 / 2 - 1;// G#7/Ab7
localparam A7_divider = base_clock_frequency			/ 3520.00 / 2 - 1;// A7		
localparam Ad7_Bb7_divider = base_clock_frequency	/ 3729.31 / 2 - 1;// A#7/Bb7
localparam B7_divider = base_clock_frequency			/ 3951.07 / 2 - 1;// B7		
localparam C8_divider = base_clock_frequency			/ 4186.01 / 2 - 1;// C8		
localparam Cd8_Db8_divider = base_clock_frequency	/ 4434.92 / 2 - 1;// C#8/Db8
localparam D8_divider = base_clock_frequency			/ 4698.63 / 2 - 1;// D8		
localparam Dd8_Eb8_divider = base_clock_frequency	/ 4978.03 / 2 - 1;// D#8/Eb8
localparam E8_divider = base_clock_frequency			/ 5274.04 / 2 - 1;// E8		
localparam F8_divider = base_clock_frequency			/ 5587.65 / 2 - 1;// F8		
localparam Fd8_Gb8_divider = base_clock_frequency	/ 5919.91 / 2 - 1;// F#8/Gb8
localparam G8_divider = base_clock_frequency			/ 6271.93 / 2 - 1;// G8		
localparam Gd8_Ab8_divider = base_clock_frequency	/ 6644.88 / 2 - 1;// G#8/Ab8
localparam A8_divider = base_clock_frequency			/ 7040.00 / 2 - 1;// A8		
localparam Ad8_Bb8_divider = base_clock_frequency	/ 7458.62 / 2 - 1;// A#8/Bb8
localparam B8_divider = base_clock_frequency			/ 7902.13 / 2 - 1;// B8		

//max clkdivider 305809 = C0_divider -> 19 bit

reg [18:0] clkdivider;
always @*
	case(note)
		0:			clkdivider = C0_divider;
		1:			clkdivider = Cd0_Db0_divider;
		2:			clkdivider = D0_divider;		
		3:			clkdivider = Dd0_Eb0_divider;
		4:			clkdivider = E0_divider;		
		5:			clkdivider = F0_divider;		
		6:			clkdivider = Fd0_Gb0_divider;
		7:			clkdivider = G0_divider;		
		8:			clkdivider = Gd0_Ab0_divider;
		9:			clkdivider = A0_divider;		
		10:		clkdivider = Ad0_Bb0_divider;
		11:		clkdivider = B0_divider;		
		12:		clkdivider = C1_divider;		
		13:		clkdivider = Cd1_Db1_divider;
		14:		clkdivider = D1_divider;		
		15:		clkdivider = Dd1_Eb1_divider;
		16:		clkdivider = E1_divider;		
		17:		clkdivider = F1_divider;		
		18:		clkdivider = Fd1_Gb1_divider;
		19:		clkdivider = G1_divider;		
		20:		clkdivider = Gd1_Ab1_divider;
		21:		clkdivider = A1_divider;		
		22:		clkdivider = Ad1_Bb1_divider;
		23:		clkdivider = B1_divider;		
		24:		clkdivider = C2_divider;		
		25:		clkdivider = Cd2_Db2_divider;
		26:		clkdivider = D2_divider;		
		27:		clkdivider = Dd2_Eb2_divider;
		28:		clkdivider = E2_divider;		
		29:		clkdivider = F2_divider;		
		30:		clkdivider = Fd2_Gb2_divider;
		31:		clkdivider = G2_divider;		
		32:		clkdivider = Gd2_Ab2_divider;
		33:		clkdivider = A2_divider;		
		34:		clkdivider = Ad2_Bb2_divider;
		35:		clkdivider = B2_divider;		
		36:		clkdivider = C3_divider;		
		37:		clkdivider = Cd3_Db3_divider;
		38:		clkdivider = D3_divider;		
		39:		clkdivider = Dd3_Eb3_divider;
		40:		clkdivider = E3_divider;		
		41:		clkdivider = F3_divider;		
		42:		clkdivider = Fd3_Gb3_divider;
		43:		clkdivider = G3_divider;		
		44:		clkdivider = Gd3_Ab3_divider;
		45:		clkdivider = A3_divider;		
		46:		clkdivider = Ad3_Bb3_divider;
		47:		clkdivider = B3_divider;		
		48:		clkdivider = C4_divider;		
		49:		clkdivider = Cd4_Db4_divider;
		50:		clkdivider = D4_divider;		
		51:		clkdivider = Dd4_Eb4_divider;
		52:		clkdivider = E4_divider;		
		53:		clkdivider = F4_divider;		
		54:		clkdivider = Fd4_Gb4_divider;
		55:		clkdivider = G4_divider;		
		56:		clkdivider = Gd4_Ab4_divider;
		57:		clkdivider = A4_divider;		
		58:		clkdivider = Ad4_Bb4_divider;
		59:		clkdivider = B4_divider;		
		60:		clkdivider = C5_divider;		
		61:		clkdivider = Cd5_Db5_divider;
		62:		clkdivider = D5_divider;		
		63:		clkdivider = Dd5_Eb5_divider;
		64:		clkdivider = E5_divider;		
		65:		clkdivider = F5_divider;		
		66:		clkdivider = Fd5_Gb5_divider;
		67:		clkdivider = G5_divider;		
		68:		clkdivider = Gd5_Ab5_divider;
		69:		clkdivider = A5_divider;		
		70:		clkdivider = Ad5_Bb5_divider;
		71:		clkdivider = B5_divider;		
		72:		clkdivider = C6_divider;		
		73:		clkdivider = Cd6_Db6_divider;
		74:		clkdivider = D6_divider;		
		75:		clkdivider = Dd6_Eb6_divider;
		76:		clkdivider = E6_divider;		
		77:		clkdivider = F6_divider;		
		78:		clkdivider = Fd6_Gb6_divider;
		79:		clkdivider = G6_divider;		
		80:		clkdivider = Gd6_Ab6_divider;
		81:		clkdivider = A6_divider;		
		82:		clkdivider = Ad6_Bb6_divider;
		83:		clkdivider = B6_divider;		
		84:		clkdivider = C7_divider;		
		85:		clkdivider = Cd7_Db7_divider;
		86:		clkdivider = D7_divider;		
		87:		clkdivider = Dd7_Eb7_divider;
		88:		clkdivider = E7_divider;		
		89:		clkdivider = F7_divider;		
		90:		clkdivider = Fd7_Gb7_divider;
		91:		clkdivider = G7_divider;		
		92:		clkdivider = Gd7_Ab7_divider;
		93:		clkdivider = A7_divider;		
		94:		clkdivider = Ad7_Bb7_divider;
		95:		clkdivider = B7_divider;		
		96:		clkdivider = C8_divider;		
		97:		clkdivider = Cd8_Db8_divider;
		98:		clkdivider = D8_divider;		
		99:		clkdivider = Dd8_Eb8_divider;
		100:		clkdivider = E8_divider;		
		101:		clkdivider = F8_divider;		
		102:		clkdivider = Fd8_Gb8_divider;
		103:		clkdivider = G8_divider;		
		104:		clkdivider = Gd8_Ab8_divider;
		105:		clkdivider = A8_divider;		
		106:		clkdivider = Ad8_Bb8_divider;
		107:		clkdivider = B8_divider;
		default: clkdivider = 19'd0;
	endcase

reg [18:0] counter;
always @(posedge clk)
	if(counter==0 || ! out_enable)
		counter <= clkdivider;
	else
		counter <= counter - 1'b1;
		
always @(posedge clk)
	if(counter==0 && out_enable) speaker <= ~speaker;
	else if(!out_enable) speaker <= 1'b0;

endmodule

/////////////////////////////////////////////////////

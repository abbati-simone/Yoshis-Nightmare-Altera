`timescale 1ns/100ps
module pll(input wire inclk0, output wire c0, output wire c1);
	//assign c0 = inclk0;
	//assign c1 = #4 ~inclk0;
endmodule

module yoshi_tb;
reg clk;
reg vgaclk;
reg reset;
reg start, up;
wire [11:0] pixel;
integer file, r;

initial begin
//$dumpfile ( "yoshi.vcd" );
//$dumpvars ;
file = $fopen("/home/abbakus/fifo", "wb"); // For writing
//filec = $fopen("/home/abbakus/fifoc", "wb"); // For writing
//$display("File descriptor %d", file);
//$display("File descriptor %d", filec);
end

display_top T
	(
		//.clk48(clk),  // clock signal, reset signal from switch
		.hard_reset(reset),
		//output wire hsync, vsync,    // outputs VGA signals to VGA port
		.rgb(pixel),      // output rgb signals to VGA DAC
		//output wire [7:0] sseg,      // output signals to control led digit segments
		//output wire [3:0] an			// output signals to multiplex seven-segment display
		.KEY_START(start),
		.KEY_UP(up)
		);

assign T.vgaclk = vgaclk;
assign T.clk = clk;
//assign T.game_reset = reset;

initial begin
reset = 0;
start = 1;
up = 1;
clk = 0;
vgaclk = 0;
#1000 reset = 1;
#1000 reset = 0;
#1000 start = 0;
#1000 start = 1;
#1000 up = 0;
#1000000 up = 1;
end

always
//#12.5 clk = !clk; //40Mhz
#5 clk = !clk; //100Mhz
always
#20 vgaclk = !vgaclk; //25Mhz

always@(posedge vgaclk)
begin
if(T.video_on)
begin
	//r = $fputc({pixel[11:8], 4'b0}, file);
	//r = $fputc({pixel[7:4], 4'b0}, file);
	//r = $fputc({pixel[3:0], 4'b0}, file);
	//$fwrite(file, "%u%u%u",{pixel[15:11], 3'b0},{pixel[10:5], 2'b0},{pixel[4:0], 3'b0});
	r = $fputc({4'b0, pixel[11:8]}, file);
	r = $fputc(pixel[7:0], file);
end
end


endmodule

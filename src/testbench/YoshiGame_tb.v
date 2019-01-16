`timescale 1ns/100ps
/*module pll(input wire inclk0, output wire c0, output wire c1);
	//assign c0 = inclk0;
	//assign c1 = #4 ~inclk0;
endmodule*/

module yoshi_tb;
reg clk;
reg vgaclk;
reg reset;
reg start, up;
wire [11:0] pixel;
integer fifo_file, r;
reg [8*2048:1] fifo_name;
reg res;

initial begin
//$dumpfile ( "yoshi.vcd" );
//$dumpvars ;
res = $value$plusargs("fifo=%s", fifo_name);
$display("Opening FIFO location %0s for writing", fifo_name);
$display("(you may need to open it for reading on the other side to unlock this operation)...");
fifo_file = $fopen(fifo_name, "wb"); // For writing
$display("FIFO opened for writing binary");
//$display("FIFO File descriptor %d", fifo_file);
end

display_top T
	(
		//.hard_reset(reset),
		.rgb(pixel),
		.KEY_START(start),
		.KEY_UP(up)
		);

assign T.vgaclk = vgaclk;
assign T.clk = clk;
assign T.hard_reset = reset;
//assign T.start = start;

//initial begin
//$display("Loading rom.");
//$readmemh("hex_memory_file.mem", T.platforms_unit.walls_color_data); //, [start_address], [end_address]
//end

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
	//$write("."); 
	//r = $fputc({pixel[11:8], 4'b0}, file);
	//r = $fputc({pixel[7:4], 4'b0}, file);
	//r = $fputc({pixel[3:0], 4'b0}, file);
	//$fwrite(file, "%u%u%u",{pixel[15:11], 3'b0},{pixel[10:5], 2'b0},{pixel[4:0], 3'b0});
	r = $fputc({4'b0, pixel[11:8]}, fifo_file);
	r = $fputc(pixel[7:0], fifo_file);
end
end


endmodule

module delay_unit
#(parameter DELAY_COUNTER_BITS, parameter DELAY_BITS, parameter COUNTER_DIVISION)
(
	input clk,
	input reset,
	input enable,
	input wire [DELAY_BITS-1:0] delay,
	output reg waiting
);

reg [DELAY_COUNTER_BITS:0] delay_counter; //1 more bit instead of [DELAY_COUNTER_BITS-1:0]

always @(posedge clk) begin
	if(reset == 1) begin
		delay_counter <= 0;
		waiting <= 1;
	end
	else if (enable == 1) begin

		delay_counter <= delay_counter + 1'b1;
		if(delay_counter <= delay << COUNTER_DIVISION << 1) begin
			waiting <= 1;
		end
		else begin
			delay_counter <= 0;
			waiting <= 0;
		end
	end
	else
		waiting <= 1;
end

endmodule

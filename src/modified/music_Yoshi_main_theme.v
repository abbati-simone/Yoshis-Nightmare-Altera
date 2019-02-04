module music_Yoshi_main_theme
	(
		input wire clk10Mhz,
		input wire clkTempoMainTheme,
		input wire reset,
		output wire out_speaker_main_theme
	);
	
	`include "../../rom_conversion/parameters/Parameters_Yoshi_general.vh"
	`include "../../rom_conversion/parameters/Parameters_ROM_Yoshi_0.vh"
	
	localparam MID_C_OFFSET = 12;
	
	localparam CHANNEL_0_IDX = 0;
	localparam CHANNEL_1_IDX = 1;
	
	wire [ROMS_number-1:0] channel_out;

	assign out_speaker_main_theme = (^channel_out[ROMS_number-1:0]);
	
	wire waiting[ROMS_number-1:0];
	
	reg [address_max_bits-1:0] current_msg[ROMS_number-1:0];

	wire [note_max_bits-1:0] note[ROMS_number-1:0];
	wire note_on[1:0];
	wire [delay_max_bits-1:0] delay[ROMS_number-1:0];
	reg [note_max_bits-1:0] note_next[ROMS_number-1:0];
	reg note_on_next[ROMS_number-1:0];
	
	localparam note_offset_0 = ROM_0_note_min-MID_C_OFFSET;
	wire [7:0] note_offset[ROMS_number-1:0];
	assign note_offset[0] = note_offset_0;
	
	localparam delay_clocks_per_tick_shift = $clog2(delay_clocks_per_tick) - 1;

	genvar i;
	generate
		for (i = 0; i < ROMS_number; i = i + 1)
		begin : playnote
			playnote channel(.clk(clk10Mhz), .out_enable(note_on_next[i]), .note(note_next[i]+note_offset[i]), .speaker(channel_out[i]));
		end
		for (i = 0; i < ROMS_number; i = i + 1)
		begin : delay_unit
			delay_unit #(.DELAY_COUNTER_BITS(delay_reg_bits), .DELAY_BITS(delay_max_bits), .COUNTER_DIVISION(delay_clocks_per_tick_shift)) du(.clk(clkTempoMainTheme), .delay(delay[i]), .waiting(waiting[i]), .reset(master_reset), .enable(1));
		end
		//begin : ROM
		//	ROM_``i`` ns(.clock(waiting[CHANNEL_``i``_IDX]), .address(current_msg[CHANNEL_``i``_IDX]), .q({note_on[CHANNEL_``i``_IDX], note[CHANNEL_``i``_IDX], delay[CHANNEL_``i``_IDX][ROM_``i``_delay_nbit-1:0]}));
		//end
	endgenerate

	MK9_Yoshi0_rom ns(.clock(waiting[CHANNEL_0_IDX]), .address(current_msg[CHANNEL_0_IDX]), .q({note_on[CHANNEL_0_IDX], note[CHANNEL_0_IDX], delay[CHANNEL_0_IDX][ROM_0_delay_nbit-1:0]}));

	reg reset_0;
	wire master_reset;
	assign master_reset = reset | (reset_0 & out_speaker_main_theme);
		
	always @(negedge waiting[CHANNEL_0_IDX]) begin 
		if (reset || current_msg[CHANNEL_0_IDX] == ROM_0_messages_len) begin
			current_msg[CHANNEL_0_IDX] <= 0;
			note_on_next[CHANNEL_0_IDX] <= 0;
			note_next[CHANNEL_0_IDX] <= 0;
			reset_0 <= 1;
		end
		else begin
			current_msg[CHANNEL_0_IDX] <= current_msg[CHANNEL_0_IDX] + 1'b1;
			note_on_next[CHANNEL_0_IDX] <= note_on[CHANNEL_0_IDX];
			note_next[CHANNEL_0_IDX] <= note[CHANNEL_0_IDX];
			reset_0 <= 0;
		end
	end

endmodule
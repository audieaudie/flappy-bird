module board_controller(
	input logic [15:0] [15:0] pillar_in
	,input logic [15:0] bird_in
	,input logic stop, clk, reset
	,output logic [15:0][15:0] red_out, green_out
);
	enum {on, off} ps, ns;
	
	logic [15:0][15:0] end_screen, running_screen;
	
	//assigning running screen
	assign running_screen[00] = 0;
	assign running_screen[01] = 0;
	assign running_screen[02] = bird_in;
	assign running_screen[03] = 0;
	assign running_screen[04] = 0;
	assign running_screen[05] = 0;
	assign running_screen[06] = 0;
	assign running_screen[07] = 0;
	assign running_screen[08] = 0;
	assign running_screen[09] = 0;
   assign running_screen[10] = 0;
	assign running_screen[11] = 0;
	assign running_screen[12] = 0;
	assign running_screen[13] = 0;
	assign running_screen[14] = 0;
	assign running_screen[15] = 0;
	
	//assigning game over screen
	assign end_screen[00] = 16'b0011111000111000;
	assign end_screen[01] = 16'b0010001001010100;
	assign end_screen[02] = 16'b0011111000110100;
	assign end_screen[03] = 16'b0000000000000000;
	assign end_screen[04] = 16'b0001111001111000;
	assign end_screen[05] = 16'b0010000000010100;
	assign end_screen[06] = 16'b0001111001111000;
	assign end_screen[07] = 16'b0000000000000000;
	assign end_screen[08] = 16'b0011111001111000;
	assign end_screen[09] = 16'b0010101000000100;
   assign end_screen[10] = 16'b0010101001111000;
	assign end_screen[11] = 16'b0000000000000100;
	assign end_screen[12] = 16'b0011111001111000;
	assign end_screen[13] = 16'b0001101001111100;
	assign end_screen[14] = 16'b0010111001010100;
	assign end_screen[15] = 16'b0000000001010100;
	
	// next state logic
	always_comb begin
		case(ps)
			on: if (stop) ns = off;
				 else ns = on;
			off: ns = off;
		endcase
	end
	
	//red output logic
	always_comb begin
		case(ps)
			on: red_out = running_screen;
			off: red_out = end_screen;
		endcase
	end
	
	//green output logic
	always_comb begin
		case(ps)
			on: green_out = pillar_in;
			default: green_out = '0;
		endcase
	end
	
	
	//DFF
	always_ff @(posedge clk) begin
		if (reset)
			ps <= on;
		else
			ps <= ns;
	end
endmodule 

module board_controller_testbench();
	logic [15:0][15:0] pillar_in;
	logic [15:0] bird_in;
	logic reset, stop;
	logic [15:0][15:0] RedPixels, GrnPixels;
	logic CLOCK_50;
	
	board_controller dut(.pillar_in, .bird_in, .clk(CLOCK_50), .reset, .stop, .red_out(RedPixels), .green_out(GrnPixels));
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; 
	end
	
	initial begin
		reset <= 1;	stop <= 0; repeat(3) @(posedge CLOCK_50);
		reset <= 0; @(posedge CLOCK_50);
		stop <= 1;	repeat(3) @(posedge CLOCK_50);
		reset <= 1;	stop <= 0; repeat(3) @(posedge CLOCK_50);
		bird_in <= 16'b0000000000000100; @(posedge CLOCK_50);
		stop <= 1;	repeat(3) @(posedge CLOCK_50);
		reset <= 1;	stop <= 0; repeat(3) @(posedge CLOCK_50);
		pillar_in[15] <= '{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0}; pillar_in[14] <= '{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0}; pillar_in[13] <= '{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0}; pillar_in[12] <= '{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0}; pillar_in[11] <= '{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0}; pillar_in[10] <= '{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0}; pillar_in[5] <= '{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0}; pillar_in[4] <= '{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0}; pillar_in[3] <= '{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0}; pillar_in[2] <= '{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0}; pillar_in[1] <= '{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0}; pillar_in[0] <= '{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0}; @(posedge CLOCK_50);
		stop <= 1;	repeat(3) @(posedge CLOCK_50);
		reset <= 1;	stop <= 0; repeat(3) @(posedge CLOCK_50);
		bird_in <= 16'b0000000000000100;	pillar_in[15] <= '{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0}; pillar_in[14] <= '{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0}; pillar_in[13] <= '{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0}; pillar_in[12] <= '{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0}; pillar_in[11] <= '{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0}; pillar_in[10] <= '{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0}; pillar_in[5] <= '{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0}; pillar_in[4] <= '{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0}; pillar_in[3] <= '{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0}; pillar_in[2] <= '{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0}; pillar_in[1] <= '{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0}; pillar_in[0] <= '{0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0};repeat(3) @(posedge CLOCK_50);
		$stop;
	end
endmodule 
		
	
		
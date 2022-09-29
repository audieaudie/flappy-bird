module pattern_generator (
	input logic [2:0] difficulty_in
	,output logic [15:0] out
	,input logic clk, enable, reset
);
	logic [8:0] in;
	
	LFSR l1 (.Q(in), .clk, .reset);
	
	integer a, count, i, difficulty;
	
	always_comb begin
		case (difficulty_in)
			3'b000: difficulty = 7;
			3'b001: difficulty = 5;
			3'b010: difficulty = 5;
			3'b011: difficulty = 4;
			3'b100: difficulty = 5;
			3'b101: difficulty = 4;
			3'b110: difficulty = 4;
			3'b111: difficulty = 3;
			default: difficulty = 7;
		endcase
	end
	
	always_ff @(posedge clk) begin
		if (reset) begin
			out <= '0;
			count <= difficulty;
		end
		else if (enable & count == 0) begin
			count <= difficulty;
			for (i = 0; i < 16; i++) begin
				if (i < a | i > (a + 4)) 
					out[i] <= 1'b1;
				else
					out[i] <= 1'b0;
			end
		end
		else if (enable & count == 1) begin // generate a random number one cycle before the generation of the pattern
			a <= in % 9;
			count <= count - 1;
		end
		else if (enable) begin
			count <= count - 1;
			out <= '0;
		end
	end
endmodule 

module pattern_generator_testbench();
	logic reset, enable;
	logic [2:0] difficulty_in;
	logic [15:0] out;
	logic CLOCK_50;
	
	pattern_generator dut (.difficulty_in, .out, .clk(CLOCK_50), .enable, .reset);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; 
	end

	initial begin
		reset <= 1; enable <= 0; repeat(10) @(posedge CLOCK_50); // reset the module
		
		reset <= 0; enable <= 1; repeat (5) @(posedge CLOCK_50);
		difficulty_in <= 3'b000; repeat(10) @(posedge CLOCK_50);
		difficulty_in <= 3'b001; repeat(10) @(posedge CLOCK_50);
		difficulty_in <= 3'b011; repeat(10) @(posedge CLOCK_50);
		difficulty_in <= 3'b111; repeat(10) @(posedge CLOCK_50);
		
		reset <= 1; repeat(10) @(posedge CLOCK_50); // reset the module
		$stop;
	end
endmodule 
// send pattern_out to both the next column driver and to the LEDs
module column_driver (
	input logic [15:0] pattern_in
	,output logic [15:0][15:0] out
	,input logic clk, enable, reset
);	
	
	always_ff @(posedge clk) begin
		if (reset)
			out <= '0;
		else if (enable) begin
			out[15] <= pattern_in;
			out[14] <= out[15];
			out[13] <= out[14];
			out[12] <= out[13];
			out[11] <= out[12];
			out[10] <= out[11];
			out[9] <= out[10];
			out[8] <= out[9];
			out[7] <= out[8];
			out[6] <= out[7];
			out[5] <= out[6];
			out[4] <= out[5];
			out[3] <= out[4];
			out[2] <= out[3];
			out[1] <= out[2];
			out[0] <= out[1];
		end
		else
			out <= out;
	end
endmodule 

module column_driver_testbench();
	logic [15:0] pattern_in;
	logic [15:0][15:0] out;
	logic CLOCK_50, enable, reset;
	
	column_driver dut(.pattern_in, .clk(CLOCK_50), .enable, .reset, .out);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; 
	end
	
	initial begin
		reset <= 1;	enable <= 0; repeat(3) @(posedge CLOCK_50);
		reset <= 0;	enable <= 1; pattern_in <= 16'b0000000000000100; @(posedge CLOCK_50);
		pattern_in <= 16'b0000000000000111; @(posedge CLOCK_50);
		pattern_in <= 16'b1110000000000111; repeat(10) @(posedge CLOCK_50);
		$stop;
	end
endmodule 
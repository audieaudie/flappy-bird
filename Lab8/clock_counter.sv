//slows down clock to desired rate
//game clock is at 2Hz
module clock_counter #(parameter CYCLE = 762) (
	input logic clk_in, reset
	,output logic enable
);
	integer count;
	
	always_ff @(posedge clk_in) begin
		if(count == 0 | reset) count <= CYCLE;
		else count <= count - 1;
	end
	
	assign enable = (count == 0);
endmodule 

module clock_counter_testbench();
	logic clk_in, reset;
	logic enable;
	logic CLOCK_50;
	
	clock_counter #(2) dut(.clk_in(CLOCK_50), .reset, .enable);
	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; 
	end
	
	initial begin
	reset <= 1; repeat(5) @(posedge CLOCK_50);
	reset <= 0; repeat(20) @(posedge CLOCK_50);
	$stop;
	end
endmodule
	
/* divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... 
  [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ... */
module clock_divider (clock, divided_clocks);
 input logic clock;
 output logic [31:0] divided_clocks = 0;

 always_ff @(posedge clock) begin
	divided_clocks <= divided_clocks + 1;
 end

endmodule 

module clock_divider_testbench();
	logic CLOCK_50;
	logic [31:0] divided_clocks;
	
	clock_divider dut(.clock(CLOCK_50), .divided_clocks);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; 
	end
	
	initial begin
		repeat(32) @(posedge CLOCK_50);
		$stop;
	end
endmodule
		
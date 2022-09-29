module LFSR(
	input logic clk, reset
	,output logic [8:0] Q
);
	logic xnor_out;
	
	assign xnor_out = (Q[8] ~^ Q[4]);
	
	always_ff @(posedge clk) begin
		if(reset) Q <= 9'b000000000;
		else Q <= {Q[7:0], xnor_out};
	end
endmodule 

module LFSR_testbench();
	logic [8:0] Q;
	logic clk, reset;
	
	LFSR dut(.clk, .reset, .Q);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2)
		clk <= ~clk;
	end
	integer i;
	
	initial begin
		reset <= 1; 						@(posedge clk);
												@(posedge clk);
		reset <= 0;							@(posedge clk);
		for(i = 0; i < 512; i++) begin
			@(posedge clk);
		end
		$stop;
	end
endmodule 
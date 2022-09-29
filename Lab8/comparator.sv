module comparator(
	input logic clk, reset
	,input logic [9:0] A, B
	,output logic value_final
);
	
	logic value;
	
		always_comb begin
			 value = (A >= B); //A = SW+LFSR , B = 512
		end

	always_ff @(posedge clk) begin
		value_final <= value;
	end
endmodule

module comparator_testbench();
	logic value_final;
	logic clk, reset;
	logic [9:0] A, B;
	//logic value;
	
	comparator dut(.clk, .reset, .A, .B, .value_final);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2)
		clk <= ~clk;
	end
	
	initial begin
		 	A = 10'b1010000001; B = 10'b1000000000; 	@(posedge clk);
																	@(posedge clk);
									  B = 10'b0000010000;	@(posedge clk);
																	@(posedge clk);
		$stop;
	end
endmodule 
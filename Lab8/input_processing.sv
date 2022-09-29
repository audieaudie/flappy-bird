module input_processing(
	input logic A, clk
	,output logic out
);
	enum{none, hold} ps, ns;
	
	
	//next state logic
	always_comb begin
		case(ps)
			none: if(A) ns = hold;
					else ns = none;
					
			hold: if(A) ns = hold;
					else ns = none;
		endcase
	end 
	
	//output logic
	always_comb begin
		case(ps)
			none: if(A) out = 1'b1;
					else out = 1'b0;
					
			hold: out = 1'b0;
		endcase
	end
	
	//DFF
	always_ff @(posedge clk) begin
		ps <= ns;
	end
endmodule 


module input_processing_testbench();
	logic clk, A;
   logic out;

   input_processing dut (.clk, .A, .out);

	// Set up the clock
	parameter CLOCK_PERIOD=100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end

	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
		@(posedge clk);	A <= 0;
		@(posedge clk);	A <= 1;
		@(posedge clk);  	A <= 0;
		@(posedge clk);  	A <= 1;
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);  	A <= 0;
		@(posedge clk);
		@(posedge clk);

		$stop; // End the simulation
	end
endmodule
module bird_light(
	input logic in, fall, uplit, downlit, clk, reset
	,output logic out
);

	enum{off, on} ps, ns;
	
	//next state logic
	always_comb begin
		case(ps)
			off: if(in & downlit) ns = on;
					else if(fall & uplit) ns = on;
					else ns = off;
			on: if(in | fall) ns = off;
				 else ns = on;
		endcase
	end
	
	//output logic
	always_comb begin
		case(ps)
			off: out = 1'b0;
			on: out = 1'b1;
		endcase
	end
	
	//DFF
	always_ff @(posedge clk) begin
		if(reset) ps <= off;
		else ps <= ns;
	end
endmodule 

module bird_light_testbench();
	logic in, fall, uplit, downlit, clk, reset;
	logic out;
	
	bird_light dut (.out, .clk, .reset, .in, .fall, .uplit, .downlit);
	
	//Set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) 
		clk <= ~clk;
	end
	
	//Set up the inputs to the design. Each line is a clock cycle
	initial begin
														@(posedge clk);
		reset <= 1;									@(posedge clk);
														@(posedge clk);
		reset <= 0;									@(posedge clk);
														@(posedge clk);
		in <= 1; fall <= 0; downlit <= 0; uplit <= 1;	@(posedge clk);
														@(posedge clk);
														@(posedge clk);
														@(posedge clk);
							 downlit <= 1; uplit <= 0;	@(posedge clk);
														@(posedge clk);
														@(posedge clk);
														@(posedge clk);
		in <= 0; fall <= 1; 							@(posedge clk);
														@(posedge clk);
														@(posedge clk);
														@(posedge clk);
							 downlit <= 0; uplit <= 1; 	@(posedge clk);
														@(posedge clk);
														@(posedge clk);
														@(posedge clk);
		in <= 1; 			 downlit <= 0; uplit <= 0;	@(posedge clk);
														@(posedge clk);
														@(posedge clk);
														@(posedge clk);
		reset <= 1;									@(posedge clk);
														@(posedge clk);
														@(posedge clk);
		in <= 0; fall <= 1; downlit <= 1; uplit <= 0;	@(posedge clk);
														@(posedge clk);
														@(posedge clk);
		in <= 1; fall <= 0; downlit <= 0; uplit <= 0;	@(posedge clk);
														@(posedge clk);
														@(posedge clk);
		in <= 0; fall <= 1; downlit <= 0; uplit <= 0;	@(posedge clk);
														@(posedge clk);
														@(posedge clk);
		$stop; 
	end 
endmodule 
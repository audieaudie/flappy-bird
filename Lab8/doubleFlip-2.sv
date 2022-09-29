module doubleFlip (
	input logic clk, reset, button
	, output logic out
);

logic out_ff1;

	always_ff @(posedge clk) begin
		if(reset == 1'b1) out_ff1 <= 1'b0;
		else out_ff1 <= button;
	end
	
	always_ff @(posedge clk) begin
		out <= out_ff1;
	end
endmodule 

module doubleFlip_testbench();
	logic clk, reset, button;
	logic out;
	
	doubleFlip dut(.clk, .reset, .button, .out);
	
	initial begin
		clk = 0;
			forever #10 clk = ~clk;
	end
	initial begin
		reset = 1;
		button <= 1;
		#100;
		reset = 0;
		button <= 0;
		#100;
		button <= 1;
		#100;
		button <= 0;
		#100;
		$stop; 
	end
endmodule 
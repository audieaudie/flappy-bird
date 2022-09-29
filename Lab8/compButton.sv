module compButton(
	input logic clk, reset
	,input logic [8:0] Q
	,input logic [8:0] SW
	,output logic out
);
	
	logic [9:0] SW_extend;
	logic [9:0] Q_extend;
	wire [9:0] adder_out;
	wire c_out;
	
	assign SW_extend = {1'b0, SW};
	assign Q_extend = {1'b0, Q};
	

	ten_bit_adder adder(.s(adder_out), .c_out(c_out), .in1(SW_extend), .in2(Q_extend), .c_in(0));
	
	
	comparator computer(.clk, .reset, .A(adder_out), .B(10'b1000000000), .value_final(out));
endmodule

module compButton_testbench();
	logic out;
	logic clk, reset;
	logic [8:0] Q;
	logic [8:0] SW;
	logic [9:0] SW_extend;
	
	compButton dut(.clk, .reset, .Q, .SW, .out);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD / 2) 
		clk <= ~clk;
	end
	
	initial begin
		reset <= 1;											@(posedge clk);
																@(posedge clk);
		reset <= 0;											@(posedge clk);
																@(posedge clk);
		Q = 9'b100000001;	SW = 9'b000000010;	   @(posedge clk);
																@(posedge clk);
		Q = 9'b000000011;								   @(posedge clk);
																@(posedge clk);
		$stop;
	end
endmodule
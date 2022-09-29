module ten_bit_adder(
	output logic [9:0] s
	,output logic c_out
	,input logic [9:0] in1, in2
	,input logic c_in
);
	
	assign {c_out, s} = in1 + in2 + c_in;
endmodule

module ten_bit_adder_testbench();
	logic [9:0] in1;
	logic [9:0] in2;
	wire [9:0] s;
	logic c_in;
	wire c_out;
	
	ten_bit_adder dut(.s(s), .c_out(c_out), .in1(in1), .in2(in2), .c_in(c_in));
	
	initial begin
		c_in = 0;
		//addition with one input 0
		in1 = 10'b0000000000; //0
		in2 = 10'b0000000001; //1
								    //output: 1
		#100;
		//addition with result 511
		in1 = 10'b0111110100; //500
		in2 = 10'b0000001011; //11
							       //output: 511
		#100;
		//addition with result 0
		in1 = 10'b1111111111; //-1
		in2 = 10'b0000000001; //1
							       //output: 0
		#100;
		//example of unsigned overflow
		in1 = 10'b1000000000; //512
		in2 = 10'b1100000000; //768
								    //output:0
		#100;
		//example of positive sign overflow
		in1 = 10'b0111000000; //448
		in2 = 10'b0100100000; //416
								    //output: -160
		#100;
		//example of negative sign overflow
		in1 = 10'b1011111111; //-257
		in2 = 10'b1000010000; //-496
								    //output: 271
		#100;
	end
endmodule

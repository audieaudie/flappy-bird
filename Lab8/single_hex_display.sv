module single_hex_display(
	input logic incr, reset, clk
	,output logic [6:0] hexout
	,output logic carryout
);
	enum{zero, one, two, three, four, five, six, seven, eight, nine} ps, ns;
	
	logic [6:0] hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7, hex8, hex9;
	assign hex0 = 7'b1000000; // 0
	assign hex1 = 7'b1111001; // 1
	assign hex2 = 7'b0100100; // 2
	assign hex3 = 7'b0110000; // 3
	assign hex4 = 7'b0011001; // 4
	assign hex5 = 7'b0010010; // 5
	assign hex6 = 7'b0000010; // 6
	assign hex7 = 7'b1111000; // 7
	assign hex8 = 7'b0000000; // 8
	assign hex9 = 7'b0010000; // 9
	
	//next state logic
	always_comb begin
		case(ps)
			zero: if(incr) ns = one;
					else ns = ps;
			one: if(incr) ns = two;
					else ns = ps;
			two: if(incr) ns = three;
					else ns = ps;
			three: if(incr) ns = four;
					else ns = ps;
			four: if(incr) ns = five;
					else ns = ps;
			five: if(incr) ns = six;
					else ns = ps;
			six: if(incr) ns = seven;
					else ns = ps;
			seven: if(incr) ns = eight;
					else ns = ps;
			eight: if(incr) ns = nine;
					else ns = ps;
			nine: if(incr) ns = zero;
					else ns = ps;
		endcase
	end
	
	//output logic
	//hex display
	always_comb begin
		case(ps)
			zero: hexout = hex0;
			one: hexout = hex1;
			two: hexout = hex2;
			three: hexout = hex3;
			four: hexout = hex4;
			five: hexout = hex5;
			six: hexout = hex6;
			seven: hexout = hex7;
			eight: hexout = hex8;
			nine: hexout = hex9;
		endcase
	end 
	//carryout
	always_comb begin
		case(ps)
			nine: if (incr) carryout = 1'b1;
					else carryout = 1'b0;
			default: carryout = 1'b0;
		endcase
	end
	
	//DFF
	always_ff @(posedge clk) begin
		if(reset) ps <= zero;
		else ps <= ns;
	end
endmodule 

module single_hex_display_testbench();
	logic incr, reset, CLOCK_50;
	logic [6:0] hexout;
	logic carryout;
	
	single_hex_display dut(.incr, .reset, .clk(CLOCK_50), .carryout, .hexout);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; 
	end
	
	initial begin
		reset <= 1; incr <= 0; @(posedge CLOCK_50);
		reset <= 0; incr <= 1; @(posedge CLOCK_50);
		incr <= 0; repeat(3) @(posedge CLOCK_50);
		incr <= 1; repeat(3) @(posedge CLOCK_50);
		reset <= 1; incr <= 1; @(posedge CLOCK_50);
		reset <= 0; repeat(10) @(posedge CLOCK_50);
		$stop;
	end
endmodule
	
	
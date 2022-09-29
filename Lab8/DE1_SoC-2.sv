// Top-level module that defines the I/Os for the DE-1 SoC board
module DE1_SoC (
	 output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 
	 ,input logic [3:0] KEY
	 ,input logic [9:0] SW
	 ,output logic [9:0] LEDR
	 ,output logic [35:0] GPIO_1
	 ,input logic CLOCK_50
);
	 // Turn off HEX displays
    //assign HEX0 = '1; score display
    //assign HEX1 = '1; score display
    //assign HEX2 = '1; score display
    assign HEX3 = '1;
    assign HEX4 = '1;
    //assign HEX5 = '1; difficulty display
	 
	 
	 /* Set up system base clock to 1526 Hz (50 MHz / 2**(14+1))
	    ===========================================================*/
	 logic [31:0] clk;
	 logic SYSTEM_CLOCK;
	 
	 clock_divider divider (.clock(CLOCK_50), .divided_clocks(clk));
	 
	 assign SYSTEM_CLOCK = clk[14]; // 1526 Hz clock signal
	 //assign SYSTEM_CLOCK = CLOCK_50; //for testbench
	 
	 /* If you notice flickering, set SYSTEM_CLOCK faster.
	    However, this may reduce the brightness of the LED board. */
	
	 
	 /* Set up LED board driver
	    ================================================================== */
	 logic [15:0][15:0]RedPixels; // 16 x 16 array representing red LEDs
    logic [15:0][15:0]GrnPixels; // 16 x 16 array representing green LEDs
	 logic RST;                   // reset - toggle this on startup
	 
	 assign RST = SW[9]; //reset is SW9
	 
	 /* Standard LED Driver instantiation - set once and 'forget it'. 
	    See LEDDriver.sv for more info. Do not modify unless you know what you are doing! */
	 LEDDriver Driver (.CLK(SYSTEM_CLOCK), .RST, .EnableCount(1'b1), .RedPixels, .GrnPixels, .GPIO_1);
	 
	 
	 /* LED board test submodule - paints the board with a static pattern.
	    Replace with your own code driving RedPixels and GrnPixels.
		 
	 	 SW9      : Reset
		 =================================================================== */
	 //processing user input
	 logic playerIn, playerOut;
	 doubleFlip df(.clk(SYSTEM_CLOCK), .reset(RST), .button(~KEY[3]), .out(playerIn));
	 input_processing ip(.A(playerIn), .clk(SYSTEM_CLOCK), .out(playerOut));
	 
	 //produce slower clock for game
	 logic en1, en2;
	 clock_counter cc1(.clk_in(SYSTEM_CLOCK), .enable(en1), .reset(RST)); //CYCLE = 762
	 clock_counter #(363) cc2(.clk_in(SYSTEM_CLOCK), .enable(en2), .reset(RST)); //CYCLE = 363
	 
	 //for testbench
	 //clock_counter #(4) cc1(.clk_in(SYSTEM_CLOCK), .enable(en1), .reset(RST)); //CYCLE = 4
	 //clock_counter #(2) cc2(.clk_in(SYSTEM_CLOCK), .enable(en2), .reset(RST)); //CYCLE = 2
	 
	 //set up bird
	 logic [15:0] bird_out;
	 bird b(.lights(bird_out), .push(playerOut), .fall(en1), .clk(SYSTEM_CLOCK), .reset(RST));
	 
	 //set up pillars
	 logic [15:0] pattern;
	 logic [15:0][15:0] pillar_out;
	 pattern_generator pg(.out(pattern), .difficulty_in(SW[2:0]), .clk(SYSTEM_CLOCK), .enable(en2), .reset(RST));
	 column_driver cd(.pattern_in(pattern), .out(pillar_out), .clk(SYSTEM_CLOCK), .enable(en2), .reset(RST));
	 
	 //set up score
	 logic stop_game, incr;
	 score_keeper sk(.green_in(GrnPixels[2][15:0]), .red_in(RedPixels[2][15:0]), .stop(stop_game), .incr, .clk(SYSTEM_CLOCK), .reset(RST));
	 
	 //hex display for score
	 logic hex0out, hex1out, hex2out;
	 single_hex_display hd1 (.incr, .carryout(hex0out), .hexout(HEX0), .clk(SYSTEM_CLOCK), .reset(RST));
	 single_hex_display hd2 (.incr(hex0out), .carryout(hex1out), .hexout(HEX1), .clk(SYSTEM_CLOCK), .reset(RST));
	 single_hex_display hd3 (.incr(hex1out), .carryout(hex2out), .hexout(HEX2), .clk(SYSTEM_CLOCK), .reset(RST));
	 
	 //hex display for difficulty
	 difficulty_display dd(.in(SW[2:0]), .out(HEX5));
	 
	 //LED board controller
	 board_controller bc(.pillar_in(pillar_out), .bird_in(bird_out), .stop(stop_game), .red_out(RedPixels), .green_out(GrnPixels), .clk(SYSTEM_CLOCK), .reset(RST));
	 
	 
endmodule 

module DE1_SoC_testbench();
	logic CLOCK_50;
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY;
	logic [9:0] SW;
	logic [35:0] GPIO_1;

	DE1_SoC dut (.CLOCK_50, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR,.SW, .GPIO_1);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		CLOCK_50 <= 0;
		forever #(CLOCK_PERIOD/2) CLOCK_50 <= ~CLOCK_50; 
	end
	
	initial begin
		SW[9] <= 1; SW[2] <= 0; SW[1] <= 0; SW[0] <= 0; KEY[3] <= 1; repeat(10) @(posedge CLOCK_50);
		SW[9] <= 0;  																				@(posedge CLOCK_50); // reset the entire module; set up difficulty
		
																		KEY[3] <= 1; 				@(posedge CLOCK_50);
																		KEY[3] <= 0;				@(posedge CLOCK_50);
																		KEY[3] <= 1; 				@(posedge CLOCK_50);
																		KEY[3] <= 0; 				@(posedge CLOCK_50);
																		KEY[3] <= 1; 				@(posedge CLOCK_50);
																		KEY[3] <= 0; 				@(posedge CLOCK_50);
																		KEY[3] <= 1; 				@(posedge CLOCK_50);
																		KEY[3] <= 0; 				@(posedge CLOCK_50);
																		KEY[3] <= 1; 				@(posedge CLOCK_50);
																		KEY[3] <= 0; 				@(posedge CLOCK_50);
		
																		KEY[3] <= 1; repeat(20) @(posedge CLOCK_50);
		$stop; 
	end
endmodule 
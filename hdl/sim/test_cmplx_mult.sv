//Testbench for top level module
`timescale 1ns / 1 ps

`include "../source/constants.sv"

module test_cmplx_mult;

localparam FILENAME = "../../matlab/mult_tests.txt";

//module cmplx_mult(input logic clk, input logic `SWITCH_SIZE SW, output logic `LED_SIZE LED);

//Inputs
logic clk;
logic `SWITCH_SIZE switches;

//Output
logic `LED_SIZE LED;
logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;

cmplx_mult dut (.*);

//Assign switches to their fucntions
logic reset_n;
logic handshake;
logic `WORD_SIZE data_in;
always_comb
begin
	switches[$high(switches)] = reset_n;
	switches[$high(switches) -1] = handshake;
	switches[$high(switches) -2 : $low(switches)] = data_in;
end

//Clock and reset
initial
begin
	clk = 0;
	reset_n = 1;
	# `SW_SIMULATION_DELAY reset_n = 0;
	# `SW_SIMULATION_DELAY reset_n = 1;
	
	forever
		#5ns clk = !clk;
end

task automatic inputWord; //Automatic is necessary for functions with pass by reference
input logic `WORD_SIZE word;
begin
	assert(handshake == 0);
	#`SW_SIMULATION_DELAY handshake = 1;
	data_in = word;
	#`SW_SIMULATION_DELAY handshake = 0;
end
endtask;

//Test a single cycle
task testCycle;
input logic `WORD_SIZE re_a_in, im_a_in, re_q_in, im_q_in, re_res_in, im_res_in;
begin
	//Input
	inputWord(re_a_in);
	inputWord(im_a_in);
	inputWord(re_q_in);
	inputWord(im_q_in);

	#`SW_SIMULATION_DELAY assert(LED == re_res_in);
	handshake = 1;
	#`SW_SIMULATION_DELAY assert(LED == im_res_in);
	handshake = 0;
	#`SW_SIMULATION_DELAY;
	
end
endtask;


integer file;
logic `WORD_SIZE re_a, im_a, re_q, im_q, re_res, im_res;
string description;
//Stimulus
initial
begin
	//Reset
	handshake = 0;
	data_in = 0;
	#`SW_SIMULATION_DELAY;
	#`SW_SIMULATION_DELAY;

	file = $fopen(FILENAME,"r");
	while($fscanf(file,"%b, %b, %b, %b, %b, %b, %s\n", re_a, im_a, re_q, im_q, re_res, im_res, description) == 7)
	begin
		testCycle(re_a, im_a, re_q, im_q, re_res, im_res);
//		assert(0) else $fatal;
	end
	$stop;
end

endmodule


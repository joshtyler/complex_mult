//Testbench for top level module
`timescale 1ns / 1 ps

`include "../source/constants.sv"

module test_cmplx_mult;

localparam FILENAME = "../../matlab/mult_tests.txt";

//module cmplx_mult(input logic clk, input logic `SWITCH_SIZE SW, output logic `LED_SIZE LED);

//Inputs
logic clk;
logic `SWITCH_SIZE SW;

//Output
logic `LED_SIZE LED;

sm dut (.*);

//Assign switches to their fucntions
logic reset_n;
logic handshake;
logic `WORD_SIZE data_in;
always_comb
begin
	SW[$high(SW)] = reset_n;
	SW[$high(SW) -1] = handshake;
	SW[$high(SW) -2 : $low(SW)] = data_in;
end

//Clock and reset
initial
begin
	clk = 0;
	reset_n = 1;
	# 10ns reset_n = 0;
	# 10ns reset_n = 1;
	
	forever
		#5ns clk = !clk;
end

task automatic inputWord; //Automatic is necessary for functions with pass by reference
input logic `WORD_SIZE word;
begin
	assert(handshake == 0);
	#1us handshake = 1;
	data_in = word;
	#1us handshake = 0;
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

	#1us assert(LED == re_res_in);
	handshake = 1;
	#1us assert(LED == im_res_in);
	handshake = 0;
	#1us;
	
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
	#32ns;

	file = $fopen(FILENAME,"r");
	while($fscanf(file,"%b, %b, %b, %b, %b, %b, %s\n", re_a, im_a, re_q, im_q, re_res, im_res, description) == 7)
	begin
		testCycle(re_a, im_a, re_q, im_q, re_res, im_res);
	end
	$stop;
end

endmodule


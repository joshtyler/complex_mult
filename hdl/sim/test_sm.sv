//Testbench for main state machine
`timescale 1ns / 1 ps

`include "../source/constants.sv"

module test_sm;

//module sm(input logic clk, input logic `SWITCH_SIZE SW, input logic `WORD_SIZE re_res, im_res, output logic `LED_SIZE LED, output logic `WORD_SIZE re_a, im_a, re_q, im_q);

//Inputs
logic clk;
logic `SWITCH_SIZE SW;
logic `WORD_SIZE re_res, im_res;

//Output
logic `LED_SIZE LED;
logic `WORD_SIZE re_a, im_a, re_q, im_q;

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
ref logic `WORD_SIZE dest_register; //Pass by reference as value changes after we call
begin
	assert(handshake == 0);
	#1us handshake = 1;
	data_in = word;
	#1us assert(dest_register == word);
	handshake = 0;
	#1us;
end
endtask;

//Test a single cycle
task testCycle;
input logic `WORD_SIZE re_a_in, im_a_in, re_q_in, im_q_in, re_res_in, im_res_in;
begin
	//Input
	inputWord(re_a_in, re_a);
	inputWord(im_a_in, im_a);
	inputWord(re_q_in, re_q);
	inputWord(im_q_in, im_q);

	re_res = re_res_in;
	im_res = im_res_in;

	#1us assert(LED == re_res_in);
	handshake = 1;
	#1us assert(LED == im_res_in);
	handshake = 0;
	#1us;
	
end
endtask;

//Stimulus
initial
begin
	//Reset
	handshake = 0;
	data_in = 0;
	#32ns;

	testCycle(1,2,3,4,5,6);
	$stop;
end

endmodule


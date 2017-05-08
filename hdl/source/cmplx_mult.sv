// Top level module

`include "constants.sv"

module cmplx_mult(input logic clk, input logic `SWITCH_SIZE SW, output logic `LED_SIZE LED);

//Inputs to multiplier
logic `WORD_SIZE re_a, im_a, re_q, im_q;

//Outputs from multiplier
logic `WORD_SIZE re_res, im_res;

//Controlling state machine
sm sm0 (.*);

//Multiplier signals
logic signed `MULT_IN_SIZE re_x, im_x, re_y, im_y;
logic signed `MULT_OUT_SIZE re_z, im_z;

localparam INPUT_SHIFT = `MULT_IN_WIDTH - `WORD_WIDTH;
localparam OUTPUT_LOW = 2*INPUT_SHIFT;
localparam OUTPUT_HIGH = OUTPUT_LOW + `WORD_WIDTH -1;


always_comb
begin
	//Note, these will be cast to signed
	re_x = re_a;
	im_x = im_a;
	re_y = re_q << INPUT_SHIFT;
	im_y = im_q << INPUT_SHIFT;

	//Note, we may have significant overflow problems because of this truncation
	re_res = re_z[OUTPUT_HIGH : OUTPUT_LOW];
	im_res = im_z[OUTPUT_HIGH : OUTPUT_LOW];
end

mult mult0
(.*);

endmodule
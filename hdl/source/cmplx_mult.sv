// Top level module

`include "constants.sv"

module cmplx_mult(
input logic clk,
input logic `SWITCH_SIZE switches,
output logic `LED_SIZE LED,
output logic [6:0] HEX0,
output logic [6:0] HEX1,
output logic [6:0] HEX2,
output logic [6:0] HEX3,
output logic [6:0] HEX4,
output logic [6:0] HEX5,
output logic [6:0] HEX6,
output logic [6:0] HEX7);

//Inputs to multiplier
logic `WORD_SIZE re_a, im_a, re_q, im_q;

//Outputs from multiplier
logic `WORD_SIZE re_res, im_res;

//We need to repackage the switches with the handshake and reset debounced
logic `SWITCH_SIZE SW;
always_comb
	SW[$high(SW)-2:$low(SW)] = switches[$high(switches)-2:$low(switches)];
//Reset
debounce #(.DELAY(`SW_BOUNCE_DELAY), .CLOCK_PERIOD(`CLOCK_PERIOD)) db0
(
	.clk(clk),
	.signal_in(switches[$high(switches)]),
	.signal_out(SW[$high(SW)])

);
//Handshake
debounce #(.DELAY(`SW_BOUNCE_DELAY), .CLOCK_PERIOD(`CLOCK_PERIOD)) db1
(
	.clk(clk),
	.signal_in(switches[$high(switches)-1]),
	.signal_out(SW[$high(SW)-1])

);

//Controlling state machine
sm sm0 (.*);

//Multiplier signals
logic signed `MULT_IN_SIZE re_x, im_x, re_y, im_y;
logic signed `MULT_OUT_SIZE re_z, im_z;

localparam INPUT_SHIFT = `MULT_IN_WIDTH - `WORD_WIDTH;
localparam OUTPUT_LOW = 2*INPUT_SHIFT -1;
localparam OUTPUT_HIGH = OUTPUT_LOW + `WORD_WIDTH -1;


always_comb
begin
	//Note, these will be cast to signed
	re_x = $signed(re_a);
	im_x = $signed(im_a);
	re_y = $signed(re_q) << INPUT_SHIFT;
	im_y = $signed(im_q) << INPUT_SHIFT;

	//Note, we may have significant overflow problems because of this truncation
	re_res = re_z[OUTPUT_HIGH : OUTPUT_LOW];
	im_res = im_z[OUTPUT_HIGH : OUTPUT_LOW];
end

mult mult0
(.*);

//Displays
logic [6:0] sw_hex[3:0];
always_comb
begin
	HEX0 = ~ sw_hex[0]; //Units
	HEX1 = ~ sw_hex[1]; //Tens
	HEX2 = ~ sw_hex[2]; //Hundreds
	HEX3 = ~ sw_hex[3]; //Sign
end

bin_to_bcd sw_disp
(
	.in(SW[7:0]),
	.disp(sw_hex)
);

logic [6:0] led_hex[3:0];
always_comb
begin
	HEX4 = ~ led_hex[0]; //Units
	HEX5 = ~ led_hex[1]; //Tens
	HEX6 = ~ led_hex[2]; //Hundreds
	HEX7 = ~ led_hex[3]; //Sign
end

bin_to_bcd led_disp
(
	.in(LED),
	.disp(led_hex)
);

endmodule
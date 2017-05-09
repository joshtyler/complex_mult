//Testbench for top level module
`timescale 1ns / 1 ps

`include "../source/constants.sv"

module test_mult;

localparam FILENAME = "../../matlab/raw_mult_tests.txt";

//mult(input logic signed `MULT_IN_SIZE re_x, im_x, re_y, im_y, output logic signed `MULT_OUT_SIZE re_z, im_z);

//Inputs
logic signed `MULT_IN_SIZE re_x, im_x, re_y, im_y;

//Output
logic signed `MULT_OUT_SIZE re_z, im_z;

mult dut (.*);

//Test a single calculation
task testNums;
input logic signed `MULT_IN_SIZE re_x_in, im_x_in, re_y_in, im_y_in;
input logic signed `MULT_OUT_SIZE re_z_in, im_z_in;
begin
	re_x = re_x_in;
	im_x = im_x_in;

	re_y = re_y_in;
	im_y = im_y_in;

	#1ns;

	assert(re_z == re_z_in) else $display("Error. Expected %x, got %x", re_z_in, re_z);
	assert(im_z == im_z_in) else $display("Error. Expected %x, got %x", im_z_in, im_z);
	
end
endtask;


integer file;
logic signed `MULT_IN_SIZE re_x_in, im_x_in, re_y_in, im_y_in;
logic signed `MULT_OUT_SIZE re_z_in, im_z_in;
string description;
//Stimulus
initial
begin

	file = $fopen(FILENAME,"r");
	while($fscanf(file,"%b, %b, %b, %b, %b, %b, %s\n", re_x_in, im_x_in, re_y_in, im_y_in, re_z_in, im_z_in, description) == 7)
	begin
		testNums(re_x_in, im_x_in, re_y_in, im_y_in, re_z_in, im_z_in);
	end
	$stop;
end

endmodule


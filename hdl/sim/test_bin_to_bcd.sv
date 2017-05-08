//Testbench for bin_to_bcd
`timescale 1ns / 1 ps
module test_bin_to_bcd;

logic [7:0] in;
logic [6:0] disp[3:0];

bin_to_bcd dut (.*);

initial
begin
	for(int i = -128; i < 128; i++)
	begin
		in = i;
		# 10ns;
	end
	$stop;
end

endmodule
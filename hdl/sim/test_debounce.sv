//Testbench for main state machine
//Debouncer

`timescale 1ns / 1 ps

module test_debounce;

//module debounce #(parameter DELAY=10ms, parameter CLOCK_PERIOD=20ns) (input logic clk, signal_in, output logic signal_out);

//Inputs
logic clk, signal_in;

//Output
logic signal_out;

debounce #(.DELAY(100ns), .CLOCK_PERIOD(10ns)) dut (.*);


//Clock
initial
begin
	clk = 0;

	forever
		#5ns clk = !clk;
end

//Stimulus
initial
begin
	signal_in = 0;
	#110ns assert(signal_out == signal_in);

	signal_in = 1;
	#20ns assert(signal_out != signal_in);
	signal_in = 0;
	#10ns signal_in = 1;
	#110ns assert(signal_out == signal_in);
	#50ns;
	$stop;
end

endmodule


//Testbench for read state machine
`timescale 1ns / 1 ps
module test_read_sm;

//Inputs
logic clk, reset_n, handshake, run;

//Output
logic read, done;

read_sm dut (.*);

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

//Stimulus
initial
begin
	handshake = 0;
	run = 0;
	#32ns;

	@(posedge clk);
	run = 1;
	@(posedge clk);
	run = 0;
	#30ns handshake = 1;
	@(posedge clk) assert(read);
	#50ns handshake = 0;
	@(posedge clk) assert(done);
	#50ns;
	$stop;
end

//Checking
property read_check; //Read must only be active for one clock cycle
	@(posedge clk) read |=> !read
endproperty

property done_check; //Read implies done after handshake goes low
	@(posedge clk) done |=> !done
endproperty

assert property (read_check);
cover property (read_check);
assert property (done_check);
cover property (done_check);
endmodule
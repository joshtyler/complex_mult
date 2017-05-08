//Debouncer
//allow input to propagate to output if delay is over threshold


module debounce #(parameter DELAY=10ms, parameter CLOCK_PERIOD=20ns) (input logic clk, signal_in, output logic signal_out);

localparam int COUNT = DELAY / CLOCK_PERIOD;

logic prev_signal;
int cnt;
initial
	cnt = 0;

always_ff @(posedge clk)
begin
	if(prev_signal != signal_in)
	begin
		cnt <= 0; //Signal change so reset counter
	end
	else if(cnt == COUNT)
	begin
		cnt <= 0; //We've reached the max count, so reseet counter and let signal go to output
		signal_out <= signal_in;
	end
	else
	begin
		cnt <= cnt +1;
	end

	prev_signal <= signal_in;
end

endmodule
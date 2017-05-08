//Read state machinne

module read_sm(input logic clk, reset_n, handshake, run, output logic read, done);

enum {HALT, WAIT_1, WAIT_0, DONE} state;


//Read state machine
always_ff @(posedge clk, negedge reset_n)
begin
	if(!reset_n)
	begin
		state <= HALT;
		read <= 0;
	end
	else
	begin
		read <= 0;
		unique case(state)
			//Reading inputs
			HALT : if(run) state <= WAIT_1;
			WAIT_1 :
			begin
				if(handshake)
				begin
					state <= WAIT_0;
					read <= '1; //We want this to be high for only one clock cycle
				end
			end
			WAIT_0 : if(!handshake) state <= DONE;
			DONE : state <= HALT;
		endcase
	end
end

always_comb
	if(state == DONE)
		done = 1;
	else
		done = 0;

endmodule
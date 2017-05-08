//Supervisory state machine

`include "constants.sv"

module sm(input logic clk, input logic `SWITCH_SIZE SW, input logic `WORD_SIZE re_res, im_res, output logic `LED_SIZE LED, output logic `WORD_SIZE re_a, im_a, re_q, im_q);

typedef enum {REAL_A, IMAG_A, REAL_Q, IMAG_Q, DISP_REAL, DISP_IMAG} stateType;
stateType state;

//Assign switches to their fucntions
logic reset_n;
logic handshake;
logic `WORD_SIZE data_in;
always_comb
begin
	reset_n = SW[$high(SW)];
	handshake = SW[$high(SW) -1];
	data_in =  SW[$high(SW) -2 : $low(SW)];
end

//Instantiate read state machine
logic read_run, read_trigger, read_done;

read_sm re_sm0
(
	.clk(clk),
	.reset_n(reset_n),
	.handshake(handshake),
	.run(read_run),
	.read(read_trigger),
	.done(read_done)
);
//Run the read state machine in the read states
always_comb
	read_run = (state == REAL_A) || (state == IMAG_A) || (state == REAL_Q) || (state == IMAG_Q);

//Main state machine
always_ff @(posedge clk, negedge reset_n)
begin
	if(!reset_n)
		state <= REAL_A;
	else
	begin
		unique case(state)
			//Reading inputs
			REAL_A: begin if(read_done) state <= IMAG_A; if(read_trigger) re_a <= data_in; end
			IMAG_A: begin if(read_done) state <= REAL_Q; if(read_trigger) im_a <= data_in; end
			REAL_Q: begin if(read_done) state <= IMAG_Q; if(read_trigger) re_q <= data_in; end
			IMAG_Q: begin if(read_done) state <= DISP_REAL; if(read_trigger) im_q <= data_in; end

			//Displaying
			DISP_REAL : if(handshake == 1) state <= DISP_IMAG;
			DISP_IMAG : if(handshake == 0) state <= REAL_A;
		endcase
	end
end

//Setup output
always_comb
begin
	if(state == DISP_REAL)
		LED = re_res;
	else if(state == DISP_IMAG)
		LED = im_res;
	else
		LED = '0;
end

endmodule
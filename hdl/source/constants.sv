`ifndef CONSTANTS_SV
`define CONSTANTS_SV

`define WORD_WIDTH 8
`define WORD_SIZE [`WORD_WIDTH-1:0]

`define MULT_IN_WIDTH (2*`WORD_WIDTH -1)
`define MULT_IN_SIZE [`MULT_IN_WIDTH-1:0]

`define MULT_OUT_WIDTH 2*`MULT_IN_WIDTH
`define MULT_OUT_SIZE [`MULT_OUT_WIDTH-1:0]

//System IO constants
`define LED_WIDTH `WORD_WIDTH
`define LED_SIZE `WORD_SIZE
`define SWITCH_WIDTH 10
`define SWITCH_SIZE[`SWITCH_WIDTH-1:0]

//System constants
`define CLOCK_PERIOD 20ns

//Use a different switch bounce delay for simulation for better performance
`ifdef MODEL_TECH
	//Simulation
	`define SW_BOUNCE_DELAY 100ns
	`define SW_SIMULATION_DELAY 200ns
`else
	//Synthesis
	`define SW_BOUNCE_DELAY 20ms
`endif

`endif
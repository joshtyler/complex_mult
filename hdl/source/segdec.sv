//7 segment decoder

module segdec(input logic [3:0] in, output logic [6:0] out);

	always_comb
	begin
		//7'bGFEDCBA
		case (in)
			4'b0000 :
				out = 7'b0111111; //0
			4'b0001 :
				out = 7'b0000110; //1
			4'b0010 :
				out = 7'b1011011; //1
			4'b0011 :
				out = 7'b1001111; //3
			4'b0100 :
				out = 7'b1100110; //4
			4'b0101 :
				out = 7'b1101101; //5
			4'b0110 :
				out = 7'b1111100; //6
			4'b0111 :
				out = 7'b0000111; //7
			4'b1000 :
				out = 7'b1111111; //8
			4'b1001 :
				out = 7'b1100111; //9
			//This will be used to show a minus sign
			4'b1010 :
				out = 7'b1000000;
			//Otherwise all off
			default :
				out = 7'b0000000;
    		endcase
	end
     
endmodule
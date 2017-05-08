//Display an 8 bit signed binary number on four BCD dispays

module bin_to_bcd(input logic [7:0] in, output logic [6:0] disp[3:0]);

logic[3:0] sign_num, units, tens, hundreds;

logic[7:0] num;
logic sign;

always_comb
begin
	sign = in[$high(in)];
	
	if(sign) //If signed
		num = 0 - in;
	else
		num = in;

	hundreds = num / 100;

	num = num - (hundreds)*100; // Remove hundreds

	tens = num / 10;

	num = num - (tens)*10; // Remove tens

	units = num;
end

//segdec(input logic [3:0] in, output logic [6:0] out)


always_comb
	if(sign)
		sign_num = 4'hA;
	else
		sign_num = 4'hF;

segdec signdec
(
	.in(sign_num),
	.out(disp[3])
);


segdec hundreddec
(
	.in(hundreds),
	.out(disp[2])
);


segdec tendec
(
	.in(tens),
	.out(disp[1])
);


segdec unitdec
(
	.in(units),
	.out(disp[0])
);
     
endmodule
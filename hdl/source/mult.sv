// Complex multiplier
// Multiplies z = x*y
// x = a + jb
// y = c + jd

`include "constants.sv"

module mult(input logic signed `MULT_IN_SIZE re_x, im_x, re_y, im_y, output logic signed `MULT_OUT_SIZE re_z, im_z);

//Assign signals from input names to names which make more sense for the mulitplier
logic signed `MULT_IN_SIZE a,b,c,d;
always_comb
begin
	a = re_x;
	b = im_x;
	c = re_y;
	d = im_y;
end

//Note z = x*y = (ac-bd) + j(ad + bc)
logic signed `MULT_OUT_SIZE ac, bd, ad, bc;

always_comb
begin
	//Calcluate intermediate values
	ac = a*c;
	bd = b*d;
	ad = a*d;
	bc = b*c;

	//Calculate output
	re_z = ac - bd;
	im_z = ad + bc;
end

endmodule
function [ real_num, imag_num ] = extract_result( num )
% Extract the bits we want to keep from the result
assert(num.WordLength == 31);
assert(num.FractionLength == 14);

real_num = real(num);
imag_num = imag(num);

real_num = real_num.bin;
imag_num = imag_num.bin;


%31 bits total. 14 fraction bits.
%Therefore bits 18-31 are fraction
%Therefore we want to keep 10-18
real_num = real_num(11:18);
imag_num = imag_num(11:18);
end


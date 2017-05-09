function [ num, num_bits ] = generate_fp_num( type )
%a has range -1 ... +1-2^(-7)
%q has range -128 ... 127

%Therefore for a
% [-2^0] [2^-1] [2^-2] [2^-3] [2^-4] [2^-5] [2^-6] [2^-7]

%For q
% [-2^7] [2^6] [2^5] [2^4] [2^3] [2^2] [2^1] [2^0]

%Therefore combined. 15 word bits, 7 fraction bits

%Setup generating function
length = 15;
frac_length = 7;
fixed = @(x) fi(x,true, length, frac_length);

assert(type == 'a' || type == 'q' || type == 'r');

if(type == 'r') %Purely random 15 bit number
    num = fixed(0);
    num_bits = dec2bin(randi(intmax('uint16'), 'uint16'),16);
    assert(size(num_bits,2) == 16);
    
    num_bits = num_bits(2:end); %Truncate to 15 bits
    
    num.bin = num_bits;
    
else %Random number confroming to either 'a' or 'q'

    %Generate a number and set the correct 8 bits to a random bit pattern
    num = fixed(0);
    rnd = dec2bin(randi(intmax('uint8'), 'uint8'),8);
    assert(size(rnd,2) == 8);

    num_bits = rnd;

    if(type == 'q')
        rnd = [rnd , '0000000']; %Append 7 blank bits to set range
    else
        if(rnd(1) == '0') %Append either 0s or 1s depending on sign
            rnd = ['0000000' , rnd];
        else
            rnd = ['1111111', rnd];
        end
    end
    assert(size(rnd,2) == 15);

    num.bin = rnd;

    if(type == 'q')
        assert(num <= 127);
        assert(num >= -128);
    else
        assert(num <= (1-2^(-7)));
        assert(num >= -1);
    end

end

end


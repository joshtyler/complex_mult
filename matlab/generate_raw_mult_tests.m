%15 bit multiplication results

%Setup fixed point math settings
fimath('OverflowAction', 'Wrap', 'RoundingMethod','Zero');

file = fopen('raw_mult_tests.txt','w');

for i = 1:10
    [a_re, a_re_bits] = generate_fp_num('r');
    [a_im, a_im_bits] = generate_fp_num('r');

    [q_re, q_re_bits] = generate_fp_num('r');
    [q_im, q_im_bits] = generate_fp_num('r');

    a = complex(a_re, a_im);
    q =  complex(q_re, q_im);

    result = a*q;

    res_re = real(result);
    res_im = imag(result);
    res_re_bits = res_re.bin;
    res_im_bits = res_im.bin;

    %Format : a_real, a_imag, q_real, q_imag, res_real, res_imag
    fprintf(file, '%s, %s, %s, %s, %s, %s,%s\n', a_re_bits, a_im_bits, q_re_bits, q_im_bits, res_re_bits, res_im_bits, ['(', num2str(a), ')*(',num2str(q),')=(',num2str(result),')']);
end

fclose(file);

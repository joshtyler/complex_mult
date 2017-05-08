%Setup fixed point math settings
fimath('OverflowAction', 'Wrap', 'RoundingMethod','Zero');

%a has range -1 ... +1-2^(-7)
%q has range -128 ... 127

file = fopen('mult_tests.txt','w');

for i = 1:10
    [a_re, a_re_bits] = generate_fp_num('a');
    [a_im, a_im_bits] = generate_fp_num('a');

    [q_re, q_re_bits] = generate_fp_num('q');
    [q_im, q_im_bits] = generate_fp_num('q');

    a = complex(a_re, a_im);
    q =  complex(q_re, q_im);

    result = a*q;

    [res_re_bits, res_im_bits] = extract_result(result);

    %Format : a_real, a_imag, q_real, q_imag, res_real, res_imag
    fprintf(file, '%s, %s, %s, %s, %s, %s,%s\n', a_re_bits, a_im_bits, q_re_bits, q_im_bits, res_re_bits, res_im_bits, ['(', num2str(a), ')*(',num2str(q),')=(',num2str(result),')']);
end

fclose(file);

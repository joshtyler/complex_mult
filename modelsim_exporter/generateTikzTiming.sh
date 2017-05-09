#!/bin/bash

SCRIPT=modelsim2latex/ms2tt

INPUT_BASE=../hdl/sim/export/

FILES=("test_cmplx_mult" "test_debounce" "test_mult" "test_read_sm" "test_sm")

OUTPUT_BASE=../report/figs/timing/


# ${#array[@]} is the number of elements in the array
# http://stackoverflow.com/questions/38602587/bash-for-loop-output-index-number-and-element
for ((i = 0; i < ${#FILES[@]}; ++i)); do
	$SCRIPT $INPUT_BASE${FILES[i]}.lst -r ns > $OUTPUT_BASE${FILES[i]}.tex
done

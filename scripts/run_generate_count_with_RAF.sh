#!/bin/bash

cd ..
export WD=$PWD
cd scripts

mkdir -p ../results/count_with_RAF/

sbatch $WD/scripts/run_generate_count_with_RAF.s \
	$WD/results/count_sample_sheet.txt \
	$WD/results/count_with_RAF/
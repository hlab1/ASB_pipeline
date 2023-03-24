#!/bin/bash

cd ..
export WD=$PWD
cd scripts

mkdir -p $WD/results/RAF/

sbatch $WD/scripts/run_generate_RAF.s \
	$WD/results/RAF_sample_sheet.txt \
	$WD/results/RAF/
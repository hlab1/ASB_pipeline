#!/bin/bash

cd ..
export WD=$PWD
cd scripts/

mkdir -p $WD/results/baalchip

source_dir=$WD/resources/BaalChIP-master/

sbatch $WD/scripts/run_Baalchip.s \
	$WD/results/count_with_RAF/C24SPL9_F1a_F1aRAF.csv \
	$WD/results/baalchip/C24SPL9_F1a_F1aRAF.bayes_report.csv \
	$source_dir
	

sbatch $WD/scripts/run_Baalchip.s \
	$WD/results/count_with_RAF/C24SPL9_F1a_F1aRAF.csv \
	$WD/results/baalchip/C24SPL9_F1a_F1aRAF.bayes_report.csv \
	$source_dir
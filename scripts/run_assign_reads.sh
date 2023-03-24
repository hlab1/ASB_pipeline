#!/bin/bash

cd ..
export WD=$PWD
cd scripts

out_merged_dir="$WD/results/merged_assigned_reads/"
out_meta_dir="$WD/results/assigned_reads_meta/"


mkdir -p $out_merged_dir
mkdir -p $out_meta_dir

sbatch $WD/scripts/run_assign_reads.s \
	$WD/resources/bam_dap/Col_bam_with_vari/ \
	C24SPL9_F1a-B \
	$WD/resources/bam_dap/C24_bam_with_vari/ \
	C24SPL9_F1a-B \
	$out_merged_dir \
	$out_meta_dir

sbatch $WD/scripts/run_assign_reads.s \
	$WD/resources/bam_dap/Col_bam_with_vari/ \
	ColSPL9_F1a-B \
	$WD/resources/bam_dap/C24_bam_with_vari/ \
	ColSPL9_F1a-B \
	$out_merged_dir \
	$out_meta_dir

sbatch $WD/scripts/run_assign_reads.s \
	$WD/resources/bam_na/Col_bam_with_vari/ \
	daplib_F1a \
	$WD/resources/bam_na/C24_bam_with_vari/ \
	daplib_F1a \
	$out_merged_dir \
	$out_meta_dir
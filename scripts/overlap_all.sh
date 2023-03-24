#!/bin/bash

cd ..
export WD=$PWD

echo "syri to het"
sh $WD/scripts/syri_to_het.sh \
	$WD/scripts/filter_het.r \
	$WD/resources/syri/C24.syri.out \
	$WD/resources/syri/vari.txt \
	$WD/resources/het/Col_ref_C24_Q_het.bed \
	$WD/resources/het/C24_ref_Col_Q_het.bed

echo "overlap het and narrowPeak"
sh $WD/scripts/overlap_het_narrowPeak.sh \
	$WD/resources/het/Col_ref_C24_Q_het.bed \
	$WD/resources/bed_dap/Col_bed/ \
	$WD/resources/bed_dap/Col_vari_bed/ \
	$WD/resources/het/C24_ref_Col_Q_het.bed \
	$WD/resources/bed_dap/C24_bed/ \
	$WD/resources/bed_dap/C24_vari_bed/

echo "overlap vari and bam"
sh $WD/scripts/overlap_vari_bam.sh \
	$WD/resources/bed_dap/Col_vari_bed/ColSPL9_F1a-B.vari.bed \
	$WD/resources/bam_dap/Col_bam/ \
	"ColSPL9_F1a-B*.bam" \
	$WD/resources/bam_dap/Col_bam_bed/ \
	$WD/resources/bam_dap/Col_bam_with_vari/ &

sh $WD/scripts/overlap_vari_bam.sh \
	$WD/resources/bed_dap/Col_vari_bed/C24SPL9_F1a-B.vari.bed \
	$WD/resources/bam_dap/Col_bam/ \
	"C24SPL9_F1a-B*.bam" \
	$WD/resources/bam_dap/Col_bam_bed/ \
	$WD/resources/bam_dap/Col_bam_with_vari/ &

sh $WD/scripts/overlap_vari_bam.sh \
	$WD/resources/bed_dap/C24_vari_bed/ColSPL9_F1a-B.vari.bed \
	$WD/resources/bam_dap/C24_bam/ \
	"ColSPL9_F1a-B*.bam" \
	$WD/resources/bam_dap/C24_bam_bed/ \
	$WD/resources/bam_dap/C24_bam_with_vari/ &

sh $WD/scripts/overlap_vari_bam.sh \
	$WD/resources/bed_dap/C24_vari_bed/C24SPL9_F1a-B.vari.bed \
	$WD/resources/bam_dap/C24_bam/ \
	"C24SPL9_F1a-B*.bam" \
	$WD/resources/bam_dap/C24_bam_bed/ \
	$WD/resources/bam_dap/C24_bam_with_vari/ &

sh $WD/scripts/overlap_vari_bam.sh \
	$WD/resources/het/Col_ref_C24_Q_het.bed \
	$WD/resources/bam_na/Col_bam/ \
	"daplib_F1a-input*.bam" \
	$WD/resources/bam_na/Col_bam_bed/ \
	$WD/resources/bam_na/Col_bam_with_vari/ &

sh $WD/scripts/overlap_vari_bam.sh \
	$WD/resources/het/C24_ref_Col_Q_het.bed \
	$WD/resources/bam_na/C24_bam/ \
	"daplib_F1a-input*.bam" \
	$WD/resources/bam_na/C24_bam_bed/ \
	$WD/resources/bam_na/C24_bam_with_vari/ &


wait


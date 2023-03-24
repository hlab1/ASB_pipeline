#!/bin/bash

cd ..
export WD=$PWD
module load bedtools/intel/2.29.2

mkdir -p $3
mkdir -p $6

cd $2
for file in *.narrowPeak; do
	echo $file
	outPath="$3$(echo ${file} | sed -e 's/nuc.*/vari.bed/')"
	bedtools intersect \
	-wo \
	-a $1 \
	-b $file | \
	awk -F '\t' -v OFS='\t' '{print $1, $2, $3, $4, $5, $6, $7, $8, $9}' \
	> $outPath
done

cd $5
for file in *.narrowPeak; do
	echo $file
	outPath="$6$(echo ${file} | sed -e 's/nuc.*/vari.bed/')"
	bedtools intersect \
	-wo \
	-a $4 \
	-b $file | \
	awk -F '\t' -v OFS='\t' '{print $1, $2, $3, $4, $5, $6, $7, $8, $9}' \
	> $outPath
done
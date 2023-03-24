#!/bin/bash

cd ..
export WD=$PWD
module load bedtools/intel/2.29.2
module load samtools/intel/1.14

mkdir -p $4
mkdir -p $5

cd $2
for file in $3; do
	echo $file
	outBedPath="$4$(echo ${file} | sed -e 's/$/.bed/')"
	outVariPath="$5$(echo ${file} | sed -e 's/.bam/.with_vari.bed/')"
	
	samtools view -L $1 $file | \
		awk -F "\t" -v OFS="\t" '{for(i=12;i<=NF;i++){if($i~/^XM/){a=$i}} print $3, $4-1, $4+length($10)-1, $1, $5, $10, a}' | \
		sed -e '/^\*/d' -e '/^contig/d' \
		> $outBedPath

	bedtools intersect \
	-wo -bed\
	-a $outBedPath \
	-b $1 \
	> $outVariPath
done
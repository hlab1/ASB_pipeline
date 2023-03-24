# ASB_pipeline
This package is used to discover genetic variatio related Allele Specific Binding events.

## I. Software and package dependencies
See dependencies.txt.

## II. Data preperation
This pipeline requires 4 types of data:
- 1. Genome variation files (.syri.out).
![image](https://user-images.githubusercontent.com/108205199/227616792-bafba190-b815-46f6-ba66-478d4b59a3c8.png)
Format details at https://schneebergerlab.github.io/syri/fileformat.html

- 2. gDNA (library) read files (.bam).
- 3. seq (dap-seq) read files (.bam).
- 4. seq (dap-seq) peak files (.narrowPeak).

## III. Workflow
### Step 1: Filter for reads overlapped with variations that are in peaks (for library only overlapped with variations).

**Usage:**
```
sh overlap_all.sh
```

- 1.1: Convert syri to het, write a file to specify the variation types to be considered. (resources/syri/vari.txt)

![image](https://user-images.githubusercontent.com/108205199/227620280-e3d691ff-64b3-472b-a647-87951e20e312.png)

In ```overlap_all.sh```
```
echo "syri to het"
sh $WD/scripts/syri_to_het.sh \
	$WD/scripts/filter_het.r \
	$WD/resources/syri/C24.syri.out \
	$WD/resources/syri/vari.txt \
	$WD/resources/het/Col_ref_C24_Q_het.bed \
	$WD/resources/het/C24_ref_Col_Q_het.bed
```

The first command filters the syri.out file to het file. It takes 4 arguments:

```sh $WD/scripts/syri_to_het.sh $WD/scripts/filter_het.r <syri.out file> <variation type file> <reference genome het> <alternative genome het>```

A het file (in bed convention) contains 9 columns: Reference location and sequence (column 1-4), alternative location and sequence (column 5-8), ID (column 9).

![image](https://user-images.githubusercontent.com/108205199/227621807-14cbe82d-62ad-4cda-9ff1-80bd661874f3.png)


- 1.2: Overlap het and narrowPeak, filter for variations in peaks.

```
echo "overlap het and narrowPeak"
sh $WD/scripts/overlap_het_narrowPeak.sh \
	$WD/resources/het/Col_ref_C24_Q_het.bed \
	$WD/resources/bed_dap/Col_bed/ \
	$WD/resources/bed_dap/Col_vari_bed/ \
	$WD/resources/het/C24_ref_Col_Q_het.bed \
	$WD/resources/bed_dap/C24_bed/ \
	$WD/resources/bed_dap/C24_vari_bed/
```
The second command takes 6 arguments:

```
sh $WD/scripts/overlap_het_narrowPeak.sh <Reference het file> <Reference narrowPeak folder> <Reference output folder> \
<Alternative het file> <Alternative narrowPeak folder> <Alternative output folder>
```
- 1.3: overlap filtered het with bam.

```
echo "overlap vari and bam"
sh $WD/scripts/overlap_vari_bam.sh \
	$WD/resources/bed_dap/Col_vari_bed/ColSPL9_F1a-B.vari.bed \
	$WD/resources/bam_dap/Col_bam/ \
	"ColSPL9_F1a-B*.bam" \
	$WD/resources/bam_dap/Col_bam_bed/ \
	$WD/resources/bam_dap/Col_bam_with_vari/ &
```
The third command takes 5 arguments:

```
sh $WD/scripts/overlap_vari_bam.sh <filtered het file> <bam folder> <selected bam files> <temp output folder> <final output folder>
```

The final output contains 17 columns: bam read location and ID (Column 1-4), read MAPQ (column 5), read sequence (column 6), read mismatch tag (column 7), het information (column 8-16), overlap length (column 17).

![image](https://user-images.githubusercontent.com/108205199/227624619-6b44737b-c4fc-49f7-9fa0-2b0eab42203b.png)


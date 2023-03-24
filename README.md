# ASB_pipeline
This package is used to discover genetic variatio related Allele Specific Binding events.

## I. Software and package dependencies
See dependencies.txt.

## II. Data preperation
This pipeline requires 4 types of data, make sure all the bam and bed files' chromosome names are in the lower case i.e. "chr1":
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

<br>

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
<br>


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

The final output (.with_vari.bed) contains 17 columns: bam read location and ID (Column 1-4), read MAPQ (column 5), read sequence (column 6), read mismatch tag (column 7), het information (column 8-16), overlap length (column 17).

![image](https://user-images.githubusercontent.com/108205199/227624619-6b44737b-c4fc-49f7-9fa0-2b0eab42203b.png)
<br>

### Step 2: Assign the reads to reference or alternative genome.
**Usage:** 
```
run_assign_reads.sh
```

This step is time-consuming, especially for assigning library reads, so it is suggested to run 1~2 library files per batch.
This step produces 2 types of files: 1) the merged reads with variation and assignment to either hap1 or hap2 (reference or alternative) and 2) summaries of reads to either genome (before and after assignment) for quality control.

- 2.1. Specify the output directories for merged reads and summary tables.
```
out_merged_dir="$WD/results/merged_assigned_reads/"
out_meta_dir="$WD/results/assigned_reads_meta/"
```
<br>

- 2.2. Assign reads.
```
sbatch $WD/scripts/run_assign_reads.s \
	$WD/resources/bam_dap/Col_bam_with_vari/ \
	C24SPL9_F1a-B \
	$WD/resources/bam_dap/C24_bam_with_vari/ \
	C24SPL9_F1a-B \
	$out_merged_dir \
	$out_meta_dir
```

Each batch takes 6 arguments:
```
sbatch $WD/scripts/run_assign_reads.s <bam mapped to reference genome with variation folder> <bam file pattern> \
	<bam mapped to alternative genome with variation folder> <bam file pattern (same as 2nd usually)> \
	$out_merged_dir $out_meta_dir
```

### Step 3. Generate Reference Allele Frequencies (RAF).
**Usage:**

```
sh run_generate_RAF.sh
```

write a sample sheet with 2 columns (tab separated): 1) group name, i.e. F1a, F1b, Col, C24..., 2) each replicated in the group.
![image](https://user-images.githubusercontent.com/108205199/227650990-5aae1acb-5285-4438-b71d-f6d2519587b6.png)

in ```run_generate_RAF.sh```, specify the location to this sheet.
```
sbatch $WD/scripts/run_generate_RAF.s <sample sheet file> $WD/results/RAF/
```
Results will be at ```results/RAF/```. Example as below.
![image](https://user-images.githubusercontent.com/108205199/227652381-d92208b8-47cf-4816-883b-44b80ec12284.png)


### Step 4. Generate count matrix with RAF.
**Usage:**

```
sh run_generate_count_with_RAF.sh
```

write a sample sheet with 3 columns (tab separated): 1) group name, i.e. ColSPL9_F1a_F1aRAF, C24SPL9_F1a_F1aRAF..., 2) each replicated in the group. 3) corresponding RAF files.
![image](https://user-images.githubusercontent.com/108205199/227652494-354a5de9-2e4d-4fb1-95e8-88f59f2afe2f.png)

in ```run_generate_count_with_RAF.sh```, specify the location to the sample sheet.

```
sbatch $WD/scripts/run_generate_count_with_RAF.s <sample sheet file> $WD/results/count_with_RAF/
```

Results will be at ```results/count_with_RAF/```. Example as below.
![image](https://user-images.githubusercontent.com/108205199/227652858-65795c41-2ae2-4368-a99b-800b10cc8f37.png)


### Step 5: Run Baalchip and generate final reports.
**Usage:**

```
sh run_Baalchip.sh
```

- 5.1. Specify the path to Baalchip (see how to get the package in dependencies.txt):
```
source_dir=<.../BaalChIP-master/>
```

- 5.2. For each count with RAF file, specify the input and out put file name.
```
sbatch $WD/scripts/run_Baalchip.s <input file (.csv)> <output file (.csv)> $source_dir
```

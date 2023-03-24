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
**Step 1:** Filter for dap-seq reads overlapped with variations that are in peaks. Filter for all library reads overlapped with variations.

**Usage:**
```
sh overlap_all.sh
```

- 1.1: write a file to specify the variation types to be considered. (resources/syri/vari.txt)

![image](https://user-images.githubusercontent.com/108205199/227620280-e3d691ff-64b3-472b-a647-87951e20e312.png)

In ```overlap_all.sh```
```
sh $WD/scripts/syri_to_het.sh \
	$WD/scripts/filter_het.r \
	$WD/resources/syri/C24.syri.out \
	$WD/resources/syri/vari.txt \
	$WD/resources/het/Col_ref_C24_Q_het.bed \
	$WD/resources/het/C24_ref_Col_Q_het.bed
```
- 1.2: 

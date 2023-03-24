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
- 1. Step 1: Filter for dap-seq reads overlapped with variations that are in peaks. Filter for all library reads overlapped with variations.
- Usage:
```
sh overlap_all.sh
```

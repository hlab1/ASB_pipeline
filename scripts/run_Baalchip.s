#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --cpus-per-task=16
#SBATCH --time=16:00:00
#SBATCH --mem=64GB
#SBATCH --job-name=baalchip


module load r/gcc/4.2.0

Rscript run_Baalchip.r $1 $2 $3

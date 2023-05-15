#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --cpus-per-task=2
#SBATCH --time=16:00:00
#SBATCH --mem=128GB
#SBATCH --job-name=generate_RAF

module load r/gcc/4.2.0

Rscript generate_RAF.r $1 $2

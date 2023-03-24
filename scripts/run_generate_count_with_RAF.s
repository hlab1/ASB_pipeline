#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --cpus-per-task=2
#SBATCH --time=16:00:00
#SBATCH --mem=128GB
#SBATCH --job-name=count
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=yz8868@nyu.edu
#SBATCH --output=slurm_count.out
#SBATCH --error=slurm_count.err


module load r/gcc/4.2.0

Rscript generate_count_with_RAF.r $1 $2

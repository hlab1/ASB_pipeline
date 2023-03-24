#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --cpus-per-task=2
#SBATCH --time=8:00:00
#SBATCH --mem=128GB
#SBATCH --job-name=assign
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=yz8868@nyu.edu
#SBATCH --output=slurm_assign_%j.out
#SBATCH --error=slurm_assign_%j.err

module load r/gcc/4.2.0

Rscript assign_reads.r $1 $2 $3 $4 $5 $6

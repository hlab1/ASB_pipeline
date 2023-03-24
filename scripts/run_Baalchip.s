#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --cpus-per-task=16
#SBATCH --time=16:00:00
#SBATCH --mem=64GB
#SBATCH --job-name=baalchip
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=yz8868@nyu.edu
#SBATCH --output=slurm_baalchip_%j.out
#SBATCH --error=slurm_baalchip_%j.err


module load r/gcc/4.2.0

Rscript run_Baalchip.r $1 $2 $3

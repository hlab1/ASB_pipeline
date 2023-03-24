#!/bin/bash

cd ..
export WD=$PWD
mkdir -p $WD/resources/het

module load r/gcc/4.2.0

Rscript $1 $2 $3 $4 $5
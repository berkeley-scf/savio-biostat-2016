#!/bin/bash
#SBATCH --job-name=test
#SBATCH -a ac_scsguest
#SBATCH -p savio
## or -p savio2 for co_biostat nodes
#SBATCH -N 1
#SBATCH -t 00:30:00
#SBATCH --mail-user=paciorek@stat.berkeley.edu

module load r
R CMD BATCH --no-save file.R file.Rout

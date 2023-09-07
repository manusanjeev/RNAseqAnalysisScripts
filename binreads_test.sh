#!/bin/bash
#SBATCH --job-name=binreads
#SBATCH --output=slurm-binreads-%j.out
#SBATCH --time=20:0:0
#SBATCH --mem=30gb
#SBATCH --account=PAS1067

## Bash strict settings
set -euo pipefail

#Loading software
module load python

## Copy the placeholder variables
input_dir="$1"
output_dir="$2"
genome_index_dir="$3"

##Make output directory
mkdir -p $output_dir

echo "Starting BinReads.py script"
#cat repeatIDs.txt | parallel python ~/Scripts/BinReads.py ~/HauerClip/Results/samfiles/{}.fastq/*Aligned.out.sam ~/Refs/test.bed ~/HauerClip/Results/meta
#python ~/Scripts/BinReads.py ~/HauerClip/Results/samfiles/ERR1201441.fastq/*Aligned.out.sam ~/Refs/test.bed ~/HauerClip/Results/meta
python ~/Scripts/BinReads.py ~/HauerClip/Results/samfiles/ERR1201443.fastq/*Aligned.out.sam ~/Refs/martNL100.bed ~/HauerClip/Results



#not all filenames worked in the first try (out of memory). 
#The following command was used to get the runids for the ones that didnt work:
#ls -lh | head -36 | grep -o ERR....... | sort | uniq
#these were used as new input to run again

cd ~/HauerClip/Results/meta
echo "Output files:"
ls -alhS
echo "Done"
date

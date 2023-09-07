#!/bin/bash
#SBATCH --account=PAS1067
#SBATCH --output=slurm-bamsort-%j.out
#SBATCH --cpus-per-task=12
#SBATCH --time=0:30:0

## Bash settings
set -euo pipefail

## Load the software
module load samtools

## Copy the placeholder variables
input_dir="$1"
#output_dir="$2"

####Sort all bamfiles in input folder
cd $input_dir
for sample in *.bam
do
date
file=`basename $sample _Aligned.out.bam`
samtools sort -m 4G -@ 11 -o $file.bam $sample
echo completed sort $sample
echo
done

## Final Reporting
echo
echo "Listing output files:"
#cd "$output_dir"
ls -alh
echo
echo "sorted all bam files!"

#!/bin/bash
#SBATCH --account=PAS1067
#SBATCH --output=slurm-bedcoverage-%j.out
#SBATCH --cpus-per-task=8
#SBATCH --time=16:0:0

## Bash settings
set -euo pipefail

## Load the software
module load gnu
module load bedtools

## Copy the placeholder variables
input_dir="$1"
bed_file="$2"
output_file="$3"

## Initial reporting
echo "Starting bedtools script"
date
echo "Input dir:		$input_dir"
echo "Contents:"
ls $input_dir
echo "BED file used:	$bed_file"
echo "Output file:		$output_file"


##Sort before coverage
cd $input_dir

#for sample in *.bam
#do
#date
#file=`basename $sample .bam`
#sort -k1,1 -k2,2n $sample > $file.sorted.bam
#echo completed sort $sample
#echo
#done


#Calculate coverage
bedtools coverage -sorted -g ~/Refs/hg19.genome -a $bed_file -b *[1-3].bam > $output_file


## Final Reporting
echo
echo "Output file:"
head $output_file
echo
echo "Counted all bam files"

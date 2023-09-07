#!/bin/bash
#SBATCH --account=PAS1067
#SBATCH --output=slurm-bedintersect-%j.out
#SBATCH --cpus-per-task=8
#SBATCH --time=16:0:0


## Bash settings
set -euo pipefail

## Load the software
module load gnu
module load bedtools
module load samtools

## Copy the placeholder variables
input_dir="$1"
bed_file="$2"


## Initial reporting
echo "Starting bedtools script"
date
echo "Input dir:		$input_dir"
echo "Contents:"
ls $input_dir
echo "BED file used:	$bed_file"


cd $input_dir
for file in *.sorted.bam; do
file_id=`basename $file .sorted.bam`
echo processing sample $file_id
bedtools intersect -a $file -b $bed_file > "$file_id"_canon.bam
echo comleted sample $file_id
date
done

## Final Reporting
echo
echo "Output files:"
ls -alh $input_dir | grep canon
echo
echo "filtered all bam files"




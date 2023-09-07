#!/bin/bash
#SBATCH --account=PAS1067
#SBATCH --output=slurm-fastqdump-%j.out
#SBATCH --cpus-per-task=6
#SBATCH --time=2:0:0

# Bash strict settings
set -euo pipefail

## Load the software
module load sratoolkit/2.10.7
module load miniconda3

## Copy the placeholder variables
input_file="$1"
output_dir="$2" 

## Initial reporting
echo "Starting fastqdump script"
date
echo "Input file:   $input_file"
echo "Contents:"
cat $input_file
echo "Output dir:         $output_dir"
echo

## Create the output dir if needed
mkdir -p "$output_dir"

##load enironment for gnu parallel
source activate local

## Run Fastqdump
#For single end:
cat $input_file | parallel fastq-dump -X 10000000000 {}
#For paired end:
#cat $input_file| cut -f 1 | parallel fastq-dump -X 10000000000 --split-files {}
## Move files to output directory
mv *.fastq $output_dir

## Final reporting
echo
echo "Listing output files:"
ls -lh "$output_dir"

echo
echo "Done with fastq-dump script"
date

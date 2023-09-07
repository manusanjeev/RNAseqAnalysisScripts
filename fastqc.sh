#!/bin/bash
#SBATCH --account=PAS1067
#SBATCH --output=slurm-fastqc-%j.out
#SBATCH --cpus-per-task=4
  
## Bash strict settings
set -euo pipefail

## Load the software
module load fastqc

## Copy the placeholder variables
input_dir="$1"
output_dir="$2" 

## Initial reporting
echo "Starting FastQC script"
date
echo "Input FASTQ dir:   $input_dir"
echo "Output dir:         $output_dir"
echo

## Create the output dir if needed
mkdir -p "$output_dir"

## Run FastQC

cd $input_dir
for file in $(ls $input_dir)
do
    SAMPLE=`basename $file`
    echo
    date
    fastqc -t 4 ${SAMPLE} -o "$output_dir"
done

## Reporting
echo
echo "Listing output files:"
ls -lh "$output_dir"

echo
echo "Done with FastQC script"

##Run MultiQC
module load miniconda3
source activate local
echo "Starting MultiQC script"
mkdir -p "$output_dir"/multiqc
multiqc "$output_dir" -o "$output_dir"/multiqc

## Final reporting
echo
echo "Done with MultiQC script"
date
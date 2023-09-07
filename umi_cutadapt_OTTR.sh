#!/bin/bash
#SBATCH --job-name=umi-ex_trim
#SBATCH --output=slrm-umi_cutadapt-%j.out
#SBATCH --time=1:0:0
#SBATCH --cpus-per-task=4
#SBATCH --account=PAS1067

## Bash strict settings
set -euo pipefail

## Load the software
module load miniconda3
source activate local

## Copy the placeholder variables
#input directory
input_dir="$1"

## Initial reporting
echo "Starting umi_extract + cutadapt script"
echo "Input folder:       $input_dir"
echo "Contents:"
ls $input_dir
echo
echo

##Steps followed in the following lines of code
#1. Umi_tools to extract 5 nt random sequence at the 5'end (read start)
#   and add to headers in fastq file. Output file1 generated.
#2. cutadapt to remove adapter sequences on Output file 1. Output file2 generated.

#Reads processed in loop
cd $input_dir

ad1=GATCGGAAGAGCACACGTCTGAACTCCAGTCAC

for id in $(ls)
do
echo "started: trimming file ${id}"
date
#cutadapt -m 20 -j 0 -a $ad1 ${id}| \
#cutadapt -u 7 -j 0 --rename='{id}_{cut_prefix}' - | \
#cutadapt -u -1 -j 0 --rename='{id}{cut_suffix}' - > ${id}trim.fq

echo "finished trimming of $id"
echo
done

cutadapt -q 10 -m 20 -M 65 -j 0 SRR23242343.fq > SRR23242343trim.fq
cutadapt -q 10 -m 20 -M 65 -j 0 SRR23242342.fq > SRR23242342trim.fq
cutadapt -q 10 -m 20 -M 105 -j 0 SRR23242340.fq > SRR23242340trim.fq
cutadapt -q 10 -m 20 -M 105 -j 0 SRR23242341.fq > SRR23242341trim.fq

echo "COMPLETED: ADAPTER TRIMMING FOR ALL SAMPLES"
echo

## Final reporting
echo
echo "Done with script"
echo
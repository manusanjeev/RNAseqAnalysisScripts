#!/bin/bash
#SBATCH --job-name=umi-ex
#SBATCH --output=slrm-umi_-%j.out
#SBATCH --time=4:0:0
#SBATCH --cpus-per-task=6
#SBATCH --account=PAS1067

## Bash strict settings
set -euo pipefail

## Load the software
module load fastqc
module load miniconda3
source activate local

## Copy the placeholder variables
#input file with runIDs
input_readfile1="$1"
#input reads directory
input_readfile2="$2"

## Initial reporting
echo "Starting umi_extract + trimmomatic script"
date
echo "Input file1:       $input_readfile1"
echo "Input file2:        $input_readfile2"
echo
echo

echo "starting UMItools"
date

umi_tools extract -I $input_readfile1 --bc-pattern=NNNNNNNNNNNN \
  --read2-in=$input_readfile1 --stdout=umi.1.fastq.gz \
  --read2-out=umi.2.fastq.gz

  ## Final reporting
echo
echo "Done with umi"
date

#adapter trimming, cutadapt
ad1=AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT
ad2=AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC
cutadapt -m 20 --nextseq-trim=20 \
-a $ad2";o=4" -A N{12}$ad1";o=16" \
-o trim_1.fq.gz -p trim_2.fq.gz \
umi.1.fastq.gz umi.2.fastq.gz


## Final reporting
echo
echo "Done with adapter trim"
date


fastqc trim_1.fq.gz


echo "Done"
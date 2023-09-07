#!/bin/bash
#SBATCH --job-name=umi-ex_trim
#SBATCH --output=slrm-umi_cutadapt-%j.out
#SBATCH --time=12:0:0
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
#1. Umi_tools to extract 12 nt random sequence at the 5'end (read start)  of read1 
#   and add to headers in paired fastq file. Output file1 generated.
#2. cutadapt to remove adapter sequences on Output file 1. Output file2 generated.

#Reads processed in loop
cd $input_dir
for id in $(ls)
do
echo "starting umi extraction: ${id}"
date
cd ${id}
###Raw files are compressed and have the extension <.fq.gz> 
### umi_tools extract can take input in compressed format and output in uncompressed format based on input/output extension
read2=$(ls|grep _3.fq.gz)
umi_tools extract  -I *_1.fq.gz --bc-pattern=NNNNNNNNNNNN --read2-in=$read2 \
--stdout=${id}umi_1.fq --read2-out=${id}umi_2.fq --log=${id}umilog.txt
echo "finished umi extraction of $id"
echo
cd ..
done
echo "COMPLETED:UMI EXTRACTION FOR ALL SAMPLES"
echo


#adapter trimming, cutqadapt'
echo "Starting adapter trimming using Cutadapt"

ad1=AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT
ad2=AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC

for id in $(ls)
do
echo "started: trimming file ${id}"
date
cd ${id}
cutadapt -m 20 --nextseq-trim=20 \
-a $ad2";o=4" -A N{12}$ad1";o=16" \
-o ${id}trim_1.fq -p ${id}trim_2.fq \
*umi_1.fq *umi_2.fq
echo "finished trimming of $id"
echo
cd ..
done

echo "COMPLETED: ADAPTER TRIMMING FOR ALL SAMPLES"
echo


## Final reporting
echo
echo "Done with script"
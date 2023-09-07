#!/bin/bash
#SBATCH --account=PAS1067
#SBATCH --output=slurm-featurecounts-%j.out
#SBATCH --cpus-per-task=4
#SBATCH --time=2:0:0

## Bash settings
set -euo pipefail

## Load the software
module load miniconda3
source activate local
module load subread

## Copy the placeholder variables
input_dir="$1"
gtf_file=~/Refs/Homo_sapiens.GRCh38.100.chr.gtf
output_file="$2"

## Initial reporting
echo "Starting Featurecounts script"
date
echo "Input dir:       $input_dir"
echo "Contents:"

ls $input_dir
#ls $input_dir>input.txt
echo "GTF annotation:   $gtf_file"
echo "Output file:      $output_file"


cat RunIDs | parallel -j 1 echo "$input_dir{}.fastq/*.sam" |\
 xargs featureCounts -p -a $gtf_file -o $output_file 

#cat $input_file | parallel -j 1 echo "Results/star/{}_trim.fastq/*.bam" |\xargs featureCounts -p -a $gtf_file -o $output_file 
## Final reporting
echo
echo "Listing contents of output file:"
cat $output_file | head
echo "number of lines:"
cat $output_file | wc -l
echo  "Done"
date

#!/bin/bash
#SBATCH --job-name=kallistoquant
#SBATCH --output=slrm-kquant-%j.out
#SBATCH --time=3:0:0
#SBATCH --cpus-per-task=16
#SBATCH --account=PAS1067

## Bash strict settings
set -euo pipefail

## Load the software
module load kallisto

## Copy the placeholder variables
#input directory
input_dir="$1"
output_dir="$2"
kindex=~/Refs/kallistotxindex.idx

## Initial reporting
echo "Starting kallisto psuedoalignment"
echo "Input folder:			$input_dir"
echo "Contents:"
ls $input_dir
echo "Output folder:		$output_dir"
echo "Index used:			$kindex"
echo
echo


##This script takes in the deduplicated fastqfiles 
###and performs pseudoalignment to calculate transcript levels

#Fastq files processed in a loop
cd $input_dir
for id in $(ls)
do
echo "starting sample: ${id}"
date
name=`basename $id .fastq`
mkdir -p $output_dir/${name}
##add -b 50 bootstrapping as required
#kallisto quant -t 14 -i $kindex -o $output_dir/${name} ${id}read1.fq ${id}read2.fq
kallisto quant --single -t 14 -i $kindex -l 50 -s 10 -o $output_dir/${name} ${input_dir}${id}

echo "finished alignment of sample $id"
echo
cd ..
done

## Final reporting

echo "COMPLETED: Alignments for all samples."
echo
echo "Done with script"
date
#!/bin/bash
#SBATCH --account=PAS1067
#SBATCH --output=slurm-samtobam-%j.out
#SBATCH --cpus-per-task=12
#SBATCH --time=2:0:0

## Bash settings
set -euo pipefail

## Load the software
module load samtools

## Copy the placeholder variables
input_dir="$1"
output_dir="$2"

##Convert to bam
cd $input_dir
mkdir -p $output_dir

for file in *.sam
do
 SAMPLE=`basename $file .sam`
 echo "processing sample $SAMPLE"
 date
 samtools view -bS -o $output_dir/$SAMPLE.bam $SAMPLE.sam
 echo "completed sample $file"
done

## Final Reporting
echo
echo "Listing output files:"
cd "$output_dir"
ls -alh
echo
echo "converted all sam files to bam format"
#!/bin/bash
#SBATCH --account=PAS1067
#SBATCH --output=slurm-bamindexing-%j.out
#SBATCH --cpus-per-task=12
#SBATCH --time=2:0:0

## Bash strict settings
set -euo pipefail

## Load the software
module load samtools

## Copy the placeholder variables
#star output folder
input_dir="$1"
#output folder to be made
#output_dir="$2"

## Initial reporting
echo "Starting indexing for bamfiles"
date
echo "Input dir:   $input_dir"
#echo "Output dir:   $output_dir"

#make outputdir
#mkdir -p "$output_dir"

# Run samtools index to index bam files in each subfolder
cd $input_dir
for file in $(ls $input_dir)
do
 SAMPLE=`basename $file`
 echo "processing sample $file"
 date
 #cd "$input_dir"/"${SAMPLE}"
 #samtools index -@ 10 *.bam
 samtools sort -o "$file"sorted.bam -@ 10 $file
 samtools index -@ 10 "$file"sorted.bam
 #cp *.bam "$output_dir"
 #cp *.bai "$output_dir"
 echo "completed sample $file"
 
done

## Final Reporting
echo
echo "Listing output files:"
#cd "$output_dir"
ls -alh
echo
echo "Done with bamfile indexing"


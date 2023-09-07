#!/bin/bash
#SBATCH --job-name=samfilter
#SBATCH --output=slurm-samfilter-%j.out
#SBATCH --time=2:0:0
#SBATCH --mem=30gb
#SBATCH --account=PAS1067

## Bash strict settings
set -euo pipefail

#Loading software
module load samtools

## Copy the placeholder variables
#folder with input samfiles
input_dir="$1"
#output folder to be made
output_dir="$2"

## Initial reporting
echo "Starting samtools filtering"
date
echo "Input dir:   $input_dir"
echo "Output dir:   $output_dir"

#make outputdir
mkdir -p "$output_dir"

# Run samtools
cd $input_dir
for file in *.sam
do
 SAMPLE=`basename $file .sam`
 NewName=`basename $file _Aligned.out.sam`
 echo "processing sample $file"
 date
 samtools view -h -q 255 -F 4 ${SAMPLE}.sam > ${NewName}.sam
 mv ${NewName}.sam "$output_dir"
 echo "completed sample $file"
 date
done

## Final Reporting
echo
echo "Listing output files:"
cd "$output_dir"
ls -alh
echo
echo "Done with samfile filtering"
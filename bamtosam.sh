#!/bin/bash
#SBATCH --account=PAS1067
#SBATCH --output=slurm-bamtosam-%j.out
#SBATCH --cpus-per-task=12
#SBATCH --time=2:0:0

## Bash settings
set -euo pipefail

## Load the software
module load samtools

## Copy the placeholder variables
input_dir="$1"
output_dir="$2"


cd $input_dir

for X in $(ls $input_dir)
do
 echo "processing sample $X"
 file=`basename $X _0dedup.bam`
 echo $file
 echo 
 echo Contents
 ls
 echo
 date
 samtools view -@ 10 -h $X > "${file}".sam
 mv *.sam "$output_dir"
 echo "completed sample $file"
 date
done

## Final Reporting
echo
echo "Listing output files:"
cd "$output_dir"
ls -alh
echo
echo "Done with bamfile indexing"
#!/bin/bash
#SBATCH --account=PAS1067
#SBATCH --output=slurm-star-sam-%j.out
#SBATCH --cpus-per-task=16
#SBATCH --time=6:0:0
#SBATCH --mem=60gb

## Bash strict settings
set -euo pipefail

## Load the software
module load star

## Copy the placeholder variables
input_fastq_dir="$1"
output_dir="$2"
genome_index_dir="$3"

## Initial reporting
echo "Starting Star script"
date
echo "Input FASTQ dir:   $input_fastq_dir"
echo "Output dir:        $output_dir"
echo "Genome index dir:  $genome_index_dir"

# Run STAR to map the FASTQ file
#STAR --genomeLoad LoadAndExit --genomeDir $genome_index_dir
for file in $(ls $input_fastq_dir)
do
 SAMPLE=`basename $file`
 echo "processing sample $file"
 date
 ## Create the output dir
 mkdir -p "$output_dir"/"${SAMPLE}"
 cd "$output_dir"/"${SAMPLE}"
 STAR\
   --runThreadN 10 \
   --genomeDir $genome_index_dir \
   --readFilesIn $input_fastq_dir/${SAMPLE} \
   --outSAMmapqUnique \
   --outFileNamePrefix "${SAMPLE}"
 echo "completed sample $file"
 date
done


## Final Reporting
echo
echo "Listing output files:"
cd "$output_dir"
du -sh * 
echo
echo "Done with Star script"

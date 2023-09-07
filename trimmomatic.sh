#!/bin/bash
#SBATCH --job-name=trimmomatic
#SBATCH --output=slrm-trimmo-%j.out
#SBATCH --time=2:0:0
#SBATCH --cpus-per-task=6
#SBATCH --account=PAS1067

## Bash strict settings
set -euo pipefail

# Load the module
module load trimmomatic/0.38

# Copy the placeholder variables
input_fastq1=$1    # One of our "raw" FASTQ files in data/fastq
input_fastq2=$2    # Second "raw" FASTQ file in data/fastq

# Run Trimmomatic
java -jar "$TRIMMOMATIC" PE \
  "$input_fastq" "$output_fastq" \
  ILLUMINACLIP:"$adapter_file":2:30:10 \
  LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

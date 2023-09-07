#!/bin/bash
#SBATCH --job-name=samMerge
#SBATCH --output=slurm-samMerge-%j.out
#SBATCH --time=0:30:0
#SBATCH --cpus-per-task=12
#SBATCH --account=PAS1067

## Bash strict settings
set -euo pipefail

#Loading software
module load samtools

date
#Converting to bam
#samtools view -@ 10 -bo SRR9604619.fastq.bam SRR9604619.fastq.sam
#samtools view -@ 10 -bo SRR9604620.fastq.bam SRR9604620.fastq.sam
#samtools view -@ 10 -bo SRR9604622.fastq.bam SRR9604622.fastq.sam
#samtools view -@ 10 -bo SRR9604621.fastq.bam SRR9604621.fastq.sam
#date

##Running Merge
samtools merge -@ 10 Monosome.bam SRR9604619.fastq.bam SRR9604620.fastq.bam
samtools merge -@ 10 Disome.bam SRR9604621.fastq.bam SRR9604622.fastq.bam
date

echo "Done with script"

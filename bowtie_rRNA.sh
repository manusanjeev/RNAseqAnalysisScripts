#!/bin/bash
#SBATCH --job-name=bowtienorRNA
#SBATCH --output=slurm-bowNorRNA-%j.out
#SBATCH --time=2:00:0
#SBATCH --mem=60gb
#SBATCH --account=PAS1067

date
set -ueo pipefail

module load bowtie1
bowtie -p 10 -l 15 /fs/scratch/PAS1067/manusanjeev/Testfolder/rRNAref/rRNAref \
 /fs/scratch/PAS1067/manusanjeev/DisomeSeq/RawReads/SRR9604621.fastq \
 --un SRR9604621_NOrRNA.fastq >SRR9604621rRNA.sam


echo polisaanam
date

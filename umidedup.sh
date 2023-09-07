#!/bin/bash
#SBATCH --job-name=umi-dedup
#SBATCH --output=slrm-umi_dedup-%j.out
#SBATCH --time=12:0:0
#SBATCH --cpus-per-task=12
#SBATCH --account=PAS1067

## Bash strict settings
set -euo pipefail

## Load the software
module load miniconda3
source activate local
module load samtools

## Copy the placeholder variables
#input directory
input_dir="$1"

## Initial reporting
echo "Starting umi_extract + cutadapt script"
echo "Input folder:       $input_dir"
echo "Contents:"
ls $input_dir
echo
echo


##This script takes in the Bam file after mapping and performs pcr deduplication using umitools

#Bam files processed in a loop
cd $input_dir
for id in $(ls)
do
echo "starting umi dedup: ${id}"
date
cd ${id}
echo "sorting...."
##Sorting
samtools sort -m 4G -o ${id}sorted.bam -@ 8 *.sam
echo "indexing...."
samtools index -@ 8 *sorted.bam
###The following command requires indexed bamfiles
#umi_tools dedup -I *sorted.bam --log=${id}deduplog.txt --method=unique --paired -S ${id}dedup.bam
echo "Umi deduplication ...."
umi_tools dedup -I *sorted.bam --log=${id}deduplog.txt --method=unique -S ${id}dedup.bam

##filtering deduplicated bam file for uniquely mapping reads
echo "filtering for uniquely mapping reads"
samtools view -@ 8 -h -q 255 *dedup.bam > ${id}unique.sam

echo "finished sample $id"
echo
cd ..
done

echo "COMPLETED: PCR deduplication for all samples"
echo


## Final reporting
echo
echo "Done with script"
date

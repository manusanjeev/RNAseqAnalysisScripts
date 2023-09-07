#!/bin/bash
#SBATCH --account=PAS1067
#SBATCH --output=slurm-star-%j.out
#SBATCH --cpus-per-task=16
#SBATCH --time=16:0:0


## Bash strict settings
set -euo pipefail

## Load the software
module load star

## Copy the placeholder variables
input_dir="$1"

## Initial reporting
echo "Starting Star script"
date
echo "Input folder:   $input_dir"
echo "Contents:"
ls $input_dir
echo


##star starting
INDEX=~/Refs/STARens100

OUTDIR=/fs/scratch/PAS1067/manusanjeev/DisomeSeq/Results/starout
mkdir -p $OUTDIR

#x=$(cat RunIDs | cut -f 1)
x=$(ls $input_dir)
cd $input_dir
for i in $x
do
echo "Starting sample ${i}"
date
mkdir -p $OUTDIR/${i}
STAR\
   --runThreadN 10 \
   --genomeDir $INDEX \
   --genomeLoad LoadAndKeep \
   --limitBAMsortRAM 20000000000 \
   --outSAMtype BAM Unsorted\
   --outFilterScoreMinOverLread 0\
   --readFilesIn ${i}/${i}trim_1.fq ${i}/${i}trim_2.fq\
   --outFileNamePrefix $OUTDIR/${i}/${i} \
   --quantMode GeneCounts
echo "completed sample ${i}"
echo
done


echo "Done with star script"
date

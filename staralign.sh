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
OUTDIR="$2"

## Initial reporting
echo "Starting Star script"
date
echo "Input folder:   $input_dir"
echo "Contents:"
ls $input_dir
echo


##star starting

INDEX=~/Refs/STARens100


mkdir -p $OUTDIR


#x=$(cat RunIDs | cut -f 1)
x=$(ls $input_dir)
for i in $x
do
name=`basename $i .fastq`
echo "Starting sample ${name}"
date
mkdir -p $OUTDIR/${i}

STAR\
   --runThreadN 12 \
   --genomeDir $INDEX \
   --genomeLoad LoadAndKeep \
   --limitBAMsortRAM 20000000000 \
   --outFilterScoreMinOverLread 0\
   --readFilesIn ${input_dir}${i}\
   --outFileNamePrefix $OUTDIR/${name}/${name} \
   --quantMode GeneCounts
echo "completed sample ${i}"
echo
done
date
echo "Done with star alignment"


####QC
module load miniconda3
source activate local
multiqc $OUTDIR/ -o $OUTDIR/..

echo "Done with multiqc"
echo
echo
echo "script completed!!!"
date

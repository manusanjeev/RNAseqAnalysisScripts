#!/bin/bash
#SBATCH --job-name=tophat
#SBATCH --output=slurm-tophatalign-%j.out
#SBATCH --time=8:0:0
#SBATCH --mem=100gb
#SBATCH --account=PAS1067

## Bash strict settings
set -euo pipefail

#Loading software

module load tophat
module load bowtie2
module load samtools

### Copy the placeholder variables
input_dir="$1"

## Initial reporting
echo "Starting Tophat script"
date
echo "Input folder:   $input_dir"
echo "Contents:"
ls $input_dir
echo


##star starting
INDEX=~/Refs/bowtie2/index

OUTDIR=/fs/scratch/PAS1067/manusanjeev/DisomeSeq/Results/tophat
mkdir -p $OUTDIR

#x=$(cat RunIDs | cut -f 1)
x=$(ls $input_dir)
cd $input_dir
for i in $x
do
echo "Starting sample ${i}"
date
mkdir -p $OUTDIR/${i}

tophat -p 8 --no-novel-juncs --output-dir $OUTDIR/${i}\
--GTF ~/Refs/bowtie2/index ${i}
echo
done

echo
echo
echo "polisaanam"
echo "Done with script"
date
#sbatch ~/Scripts/tophat.sh /fs/scratch/PAS1067/manusanjeev/DisomeSeq/Rawreads_onlyWT/
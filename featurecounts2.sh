#!/bin/bash
#SBATCH --account=PAS1067
#SBATCH --output=slurm-featurecounts-%j.out
#SBATCH --cpus-per-task=10
#SBATCH --time=2:0:0

## Bash settings
set -euo pipefail

## Load the software
module load miniconda3
source activate local
module load subread

## Copy the placeholder variables
input_dir="$1"
gtf_file=~/Refs/Homo_sapiens.GRCh38.100.chr.gtf
output_file="$2"

## Initial reporting
echo "Starting Featurecounts script"
date
echo "Input folder:       $input_dir"
echo "GTF annotation:   $gtf_file"
echo "Output file:      $output_file"

###Moving all bamfiles to one location
##Comment out this section if needed
cd $input_dir
#x=$(ls)
#mkdir Bamfiles
#for i in $x
#do
#echo poli${i}
#cd "$input_dir"${i}
#cp *.bam ../Bamfiles/
#cd ..
#done
echo
#echo "Moved bam files to one location"

#cd "$input_dir"Bamfiles

#substituting filenames
#while read old_text new_text;
#do
#for file in *;
#do
#mv -f "$file" "$(sed "s/$old_text\.bam$/$new_text.bam/g" <<< "$file")"
#done
#done < /fs/scratch/PAS1067/manusanjeev/UmassEJCseq/Results/samfiles/subs.txt

#echo "Renamed Bamfiles"
echo "Starting featurecounts"

#featureCounts -p -a $gtf_file -o $output_file *.bam
featureCounts -p -a $gtf_file -o $output_file *.sam

echo
echo "Listing contents of output file:"
cat $output_file | head
echo "number of lines:"
cat $output_file | wc -l
echo  "Done"
date
#!/bin/bash
#SBATCH --job-name=umi-ex_trimmomatic
#SBATCH --output=slrm-umi_trim-%j.out
#SBATCH --time=10:0:0
#SBATCH --cpus-per-task=6
#SBATCH --account=PAS1067

## Bash strict settings
set -euo pipefail

## Load the software
module load fastqc
module load miniconda3
module load trimmomatic
source activate local

## Copy the placeholder variables
#input file with runIDs
input_file="$1"
#input reads directory
input_dir="$2"
#output folder to be made
output_dir="$3"
####requires adapter file in parent directory(level above from the main directory in which job is submitted)

## Initial reporting
echo "Starting umi_extract + trimmomatic script"
date
echo "Input file:       $input_file"
echo "Contents:"
cat $input_file
echo "Input dir:        $input_dir"
echo "Output dir:       $output_dir"
echo

##Steps followed in the following lines of code
#1. Umi_tools to extract 5 nt random sequence at the 5'end (read start) and add to headers in fastq file. Output file1 generated
#2. Trimmomatic to cut 7 nucleotides at the 5'end(read start) and remove adapter sequences on Output file 1. Output file2 generated
#3. FastQC, MultiQC

## Create the output dir if needed
mkdir -p "$output_dir"

#Reads processed in loop
####requires adapter file in parent directory(level above from the main directory in which job is submitted)

while read -r id
do
echo "starting file $id"
date
umi_tools extract --stdin=$input_dir$id.fastq --bc-pattern=NNNNN --stdout $output_dir/"$id"_umiex.fastq
echo "completed umi extraction"
date
java -jar "$TRIMMOMATIC" SE ""$output_dir"/"$id"_umiex.fastq" ""$output_dir"/"$id"_trim.fastq" ILLUMINACLIP:"../adapters.fa":2:30:4 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 HEADCROP:7 MINLEN:20
##Note: ../adapters.fa - adapter fasta file is required
echo "completed adapter trimming"
date
fastqc -t 4 "$output_dir"/"$id"_trim.fastq -o "$output_dir"
echo "completed fastqc on final output file"
date
done < $input_file

##Run MultiQC
echo "Starting MultiQC"
multiqc "$output_dir"

#Removing unwanted fastqc files
cd $output_dir
rm -r *fastqc*

## Final reporting
echo
echo "Done with script"
date
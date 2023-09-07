## Copy the placeholder variables
#directory with sam files
input_dir="$1"
#annotations bed file
bedfile="$2"
#Outputdir
output_dir="$3"

#bash submitbinreads.sh /fs/scratch/PAS1067/manusanjeev/meClipSams/ /fs/scratch/PAS1067/manusanjeev/scripts/exon_GRCh38-E100-PC-APPRISp1-min100.bed /fs/scratch/PAS1067/manusanjeev/meClipScripts

#defining script to avoid specifying full path
script="/fs/scratch/PAS1067/manusanjeev/scripts/BinReads.py"

cd $input_dir
x=$(ls)
mkdir -p $output_dir
cd $output_dir

for i in $x
do
echo ${i}

(
echo '#!/bin/bash'
echo '#SBATCH --job-name=binreads'${i}''
echo '#SBATCH --output=slrm-'${i}'-bnrds-%j.out'
echo '#SBATCH --time=2:00:0'
echo '#SBATCH --ntasks=24'
echo '#SBATCH --account=PAS1067'
echo
echo '## Bash strict settings'
echo 'set -euo pipefail'
echo
echo '#Loading software'
echo 'module load python'
echo
echo "#Starting BinReads.py script"
echo "python $script $input_dir${i} $bedfile $output_dir"
echo
echo "echo Done ${i}!"
)>script"${i}".sh

sbatch script${i}.sh
echo "submitted script ${i}.txt"
done

echo completed loops

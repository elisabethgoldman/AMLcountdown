#!/bin/bash

#extract.sh
#SBATCH --partition=exacloud
#SBATCH --account=CEDAR
#SBATCH --time=08:00:00
#SBATCH --output=bismark_extract_%A_%a.out
#SBATCH --error=bismark_extract_%A_%a.err
#SBATCH --job-name=bismark_extract
#SBATCH --cpus-per-task=4
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=2GB
#SBATCH --array=320,324,325,326,327,330,332,334,338,339,340,341,342,344,345,347,349,352,353,355,356,359,360,361,363,364,365,368,268,271,284,293


module load bismark/0.19.0
module load samtools
bam=`sed -n ${SLURM_ARRAY_TASK_ID}p /home/groups/CEDAR/goldmael/projects/AMLclock/code/idLists/R1_bamFiles`

echo "Processing $bam" 
echo "Slurm Job ID: $SLURM_ARRAY_JOB_ID"
echo "Slurm Array ID:$SLURM_ARRAY_TASK_ID"

genome_path="/home/groups/CEDAR/Strogant/Genomes/Human/GRCh38"

# input and output directory paths are entered first and second after the shell script as command line arguments e.g., 
# sbatch extract.sh 'path/to/input/' '/path/to/output' 

in_path=$1                                                                           
out_path=$2 

bismark_methylation_extractor -s -o ${out_path} --bedGraph --comprehensive --multicore 2 --parallel 4 --genome_folder ${genome_path} ${in_path}/${bam}


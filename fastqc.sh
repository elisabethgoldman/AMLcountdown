#!/bin/bash

# fastqc standardly run
#SBATCH --partition=exacloud
#SBATCH --account=CEDAR
#SBATCH --time=02:00:00
#SBATCH --output=fastqc_%A_%a.out
#SBATCH --error=fastqc_%A_%a.err
#SBATCH --job-name=fastqc
#SBATCH --cpus-per-task=1
#SBATCH --mem=500MB
#SBATCH --array=2-838%50

module purge
module load fastqc/0.11.9

sample=`sed -n ${SLURM_ARRAY_TASK_ID}p /home/groups/CEDAR/goldmael/projects/AMLclock/code/idLists/Replicate1Bams`
echo "Slurm Job ID: $SLURM_ARRAY_JOB_ID , array number: $SLURM_ARRAY_TASK_ID"

in_path='/home/groups/CEDAR/Strogant/projects/AMLcountdown/Replicate1/dedup_combined'
out_path='/home/groups/CEDAR/goldmael/projects/AMLclock/qc/'

fastqc -t 4 -o ${out_path} ${in_path}/${sample}
if [ $? -ne 0 ]; then
  echo "An error occurred with FastQC. Exit code: $?"
  exit 1
else
  echo "FastQC complete."
fi

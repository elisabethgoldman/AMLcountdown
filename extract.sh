#!/bin/bash

#SBATCH --time=04:00:00
#SBATCH --job-name=bismark_extract
#SBATCH --cpus-per-task=4
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=550MB
#SBATCH --array=101-336%20


##define log file path
LOGFILE="combined_log_${SLURM_ARRAY_TASK_ID}.log"

##initialize log file
touch $LOGFILE

## function to handle exit signals
function finish {
  exit_status=$?
  if [ $exit_status -eq 0 ]; then
    echo "Job completed successfully." >> $LOGFILE 2>&1
  else
    echo "Job failed with exit status $exit_status." >> $LOGFILE 2>&1
  fi
}

## function to be called on exit
trap finish EXIT


module load bismark/0.19.0 >> $LOGFILE 2>&1
module load samtools >> $LOGFILE 2>&1


bam=$(sed -n "${SLURM_ARRAY_TASK_ID}p" /home/groups/CEDAR/goldmael/projects/AMLclock/code/idLists/reExtractBams) >> $LOGFILE 2>&1
baseid=$(echo "$bam" | sed -E 's/.*([P][0-9A-Za-z]{5}).*/\1/') >> $LOGFILE 2>&1

##log metadata
echo "Sample basename: $baseid" >> $LOGFILE 2>&1
echo "File name: $bam" >> $LOGFILE 2>&1
echo "Slurm Job ID: $SLURM_ARRAY_JOB_ID" >> $LOGFILE 2>&1
echo "Slurm Task ID: $SLURM_ARRAY_TASK_ID" >> $LOGFILE 2>&1

##define paths
genome_path="/home/groups/CEDAR/Strogant/Genomes/Human/GRCh38"
in_path="/home/groups/CEDAR/Strogant/projects/AMLcountdown/Replicate1/dedup_combined"
out_path="/home/groups/CEDAR/goldmael/projects/AMLclock/results/extracted/Replicate1/test2"

##run methylation extractor
bismark_methylation_extractor -s --multicore 4 --gzip --comprehensive --merge_non_CpG --bedGraph -o "${out_path}" "${in_path}/${bam}" >> $LOGFILE 2>&1


##remove non-CpG files

if [ -n "$(ls ${out_path}/Non_CpG* 2>/dev/null)" ]; then
  rm ${out_path}/Non_CpG* >> $LOGFILE 2>&1
else
  echo "No Non_CpG files found for deletion." >> $LOGFILE 2>&1
fi

sacct -j $SLURM_JOB_ID --units=G --format=JobIdRaw,Submit,Start,End,AllocNodes,ReqCPUs,AllocCPUs,TotalCPU,ReqMem,AveRSS,MaxRSS,AveVMSize,MaxVMSize,State,AveDiskWrite,MaxDiskWrite,NTasks >> $LOGFILE 2>&1

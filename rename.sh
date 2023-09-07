#!/bin/bash

# rename files

#SBATCH --partition=exacloud
#SBATCH --account=CEDAR
#SBATCH --time=02:00:00
#SBATCH --output=rename_%j.out
#SBATCH --error=rename_%j.err
#SBATCH --job-name=rename
#SBATCH --mem=2GB
#SBATCH --cpus-per-task=1


## initialize log file
log_file="log.txt"
echo "------ Script Execution: $(date) ------" >> "$log_file"

## iterate through all .cov.gz files
for filename in *.cov.gz; do
  # Extract the six character ID and R1 or R2 indicators
  id=$(echo "$filename" | sed -E 's/.*([P][0-9A-Za-z]{5}).*/\1/')
  r_indicator=$(echo "$filename" | sed -E 's/.*(R[12]).*/\1/')

  ## construct new filename
  new_filename="${id}_${r_indicator}.cov.gz"

  ## log the rename attempt
  echo "Attempting to rename: $filename to $new_filename at $(date)" >> "$log_file"

  ## rename file and check if successful
  if mv "$filename" "$new_filename"; then
    echo "Successfully renamed: $filename to $new_filename" >> "$log_file"
  else
    echo "Failed to rename: $filename to $new_filename" >> "$log_file"
  fi
done

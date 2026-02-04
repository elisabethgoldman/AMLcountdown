#!/bin/bash

#SBATCH --partition=partition
#SBATCH --account=CEDAR
#SBATCH --time=2:00:00
#SBATCH --output=manifest_%j.out
#SBATCH --error=manifest_%j.err
#SBATCH --job-name=manifest
#SBATCH --mem=4GB

DIRECTORY="/metadata/"


# Define the output file for the manifest
OUTPUT_FILE="/metdata/file_manifest.csv"

# write the header row to CSV file
echo "File Name,File Path,File Size,Checksum" > "$OUTPUT_FILE"

# Loop through files in the specified directory and append information to the CSV file
for file in "$DIRECTORY"/*.bam; do
  if [ -f "$file" ]; then
    file_name=$(basename "$file")
    file_path="$file"
    file_size=$(stat -c %s "$file")
    checksum=$(md5sum "$file" | awk '{ print $1 }')
    echo "$file_name,$file_path,$file_size,$checksum" >> "$OUTPUT_FILE"
  fi
done

echo "File manifest created: $OUTPUT_FILE"

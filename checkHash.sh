## check if hashes are identical between file renames
#!/bin/bash

#SBATCH --partition=exacloud
#SBATCH --account=CEDAR
#SBATCH --time=01:00:00
#SBATCH --output=md5sum_%j.out
#SBATCH --error=md5sum_%j.err
#SBATCH --job-name=check_md5sum
#SBATCH --mem=200MB

## columns for file1 and file2 should be ordered HashValue, FileName
file1=$1 # the file with the longer names
file2=$2


awk '{ 
    id_and_r = gensub(/.*((P[0-9A-Za-z]{5}).*(_R[12])).*/, "\\1", "g", $2); 
    id_and_r = gensub(/-[^_]*(_R[12])/, "\\1", "g", id_and_r); 
    print id_and_r "\t" $0 
}' "$file1" | sort -k1,1  > first_file_sorted.txt


awk '{ 
    id_and_r = gensub(/((P[0-9A-Za-z]{5}).*(R[12])).*/, "\\1", "g", $2); 
    print id_and_r "\t" $0 
}' "$file2" | sort -k1,1 > second_file_sorted.txt


awk '{ $1=""; print $0 }' first_file_sorted.txt > first_file_final.txt
awk '{ $1=""; print $0 }' second_file_sorted.txt > second_file_final.txt

paste first_file_final.txt second_file_final.txt | awk '$1 != $3 { print "Mismatch: " $1 " and " $3 }'

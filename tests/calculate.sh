#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

#enter the workflow's final output directory ($1)
cd $1

module load samtools/1.9

for i in *.bam; do  samtools view "$i" | md5sum; done
cat kmer.txt | md5sum

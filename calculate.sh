#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

#enter the workflow's final output directory ($1)
cd $1

#find all files, return their md5sums to std out
for i in *.bam; do  samtools view "$i" | md5sum; done
cat kmer.txt | md5sum
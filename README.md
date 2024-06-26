# novoBreak

novoBreak is a tool used in cancer genomic studies to discover SV (both somatic and germline) breakpoints. It can report accurate breakpoints of Deletions (DEL), Duplications (DUP), Inversions (INV) and Translocations (TRA) (you should consider some of them are mobile elements insertions or templated insertions). For novel insertions, we may only report the breakpoints but not the inserted sequence.

## Overview

## Dependencies

* [novobreak 1.13](https://github.com/czc/nb_distribution)


## Usage

### Cromwell
```
java -jar cromwell.jar run novoBreak.wdl --inputs inputs.json
```

### Inputs

#### Required workflow parameters:
Parameter|Value|Description
---|---|---
`normalBam`|File|Normal BAM file
`normalBai`|File|Index file for normalBam
`tumorBam`|File|Tumor BAM file
`tumorBai`|File|Index file for tumorBam
`referenceModule`|String|Modulator module that loads the reference fasta data
`referenceFasta`|String|Reference file in fasta format


#### Optional workflow parameters:
Parameter|Value|Default|Description
---|---|---|---
`outputGermlineEvents`|Boolean|false|Output germline events (false by default)
`kmerSize`|Int?|None|Kmer size, <=31 [31]
`kmerMin`|Int?|None|Minimum kmer count regarded as novo kmers [3]


#### Optional task parameters:
Parameter|Value|Default|Description
---|---|---|---
`runNovoBreak.novoBreakModule`|String|"novobreak/1.13"|novoBreak module to load in modulator
`runNovoBreak.threads`|Int|6|Requested CPU threads
`runNovoBreak.jobMemory`|Int|40|Memory (GB) allocated for this job
`runNovoBreak.timeout`|Int|6|Number of hours before task timeout


### Outputs

Output | Type | Description | Labels
---|---|---|---
`germlineBam`|File|BAM file of germline hits (empty if outputGermlineEvents is false)|vidarr_label: germlineBam
`somaticBam`|File|BAM file of somatic hits|vidarr_label: somaticBam
`kmers`|File|Called kmers|vidarr_label: kmers


## Commands
This section lists command(s) run by novobreak workflow
 
* Running novobreak
 
```
   set -euo pipefail
 
   novoBreak \
     -i ~{tumorBam} \
     -c ~{normalBam} \
     -r ~{referenceFasta} \
     ~{true="-g 1" false="" outputGermlineEvents} \
     ~{"-k " + kmerSize} \
     ~{"-m " + kmerMin} \
     -o kmer.txt
 
```
## Support

For support, please file an issue on the [Github project](https://github.com/oicr-gsi) or send an email to gsi@oicr.on.ca .

_Generated with generate-markdown-readme (https://github.com/oicr-gsi/gsi-wdl-tools/)_

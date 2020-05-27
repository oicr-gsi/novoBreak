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

Output | Type | Description
---|---|---
`germlineBam`|File|BAM file of germline hits (empty if outputGermlineEvents is false)
`somaticBam`|File|BAM file of somatic hits
`kmers`|File|Called kmers


## Niassa + Cromwell

This WDL workflow is wrapped in a Niassa workflow (https://github.com/oicr-gsi/pipedev/tree/master/pipedev-niassa-cromwell-workflow) so that it can used with the Niassa metadata tracking system (https://github.com/oicr-gsi/niassa).

* Building
```
mvn clean install
```

* Testing
```
mvn clean verify \
-Djava_opts="-Xmx1g -XX:+UseG1GC -XX:+UseStringDeduplication" \
-DrunTestThreads=2 \
-DskipITs=false \
-DskipRunITs=false \
-DworkingDirectory=/path/to/tmp/ \
-DschedulingHost=niassa_oozie_host \
-DwebserviceUrl=http://niassa-url:8080 \
-DwebserviceUser=niassa_user \
-DwebservicePassword=niassa_user_password \
-Dcromwell-host=http://cromwell-url:8000
```

## Support

For support, please file an issue on the [Github project](https://github.com/oicr-gsi) or send an email to gsi@oicr.on.ca .

_Generated with generate-markdown-readme (https://github.com/oicr-gsi/gsi-wdl-tools/)_

version 1.0
workflow novoBreak {
  input {
    File normalBam
    File normalBai
    File tumorBam
    File tumorBai
    String referenceModule
    String referenceFasta
    Boolean outputGermlineEvents = false
    Int? kmerSize
    Int? kmerMin
  }

  parameter_meta {
    normalBam: "Normal BAM file"
    normalBai: "Index file for normalBam"
    tumorBam: "Tumor BAM file"
    tumorBai: "Index file for tumorBam"
    referenceModule: "Modulator module that loads the reference fasta data"
    referenceFasta: "Reference file in fasta format"
    outputGermlineEvents: "Output germline events (false by default)"
    kmerSize: "Kmer size, <=31 [31]"
    kmerMin: "Minimum kmer count regarded as novo kmers [3]"
  }

  meta {
    author: "Savo Lazic"
    email: "savo.lazic@oicr.on.ca"
    description: "novoBreak is a tool used in cancer genomic studies to discover SV (both somatic and germline) breakpoints. It can report accurate breakpoints of Deletions (DEL), Duplications (DUP), Inversions (INV) and Translocations (TRA) (you should consider some of them are mobile elements insertions or templated insertions). For novel insertions, we may only report the breakpoints but not the inserted sequence."
    dependencies:
    [
      {
      name: "novobreak/1.13",
      url: "https://github.com/czc/nb_distribution"
      }
    ]
    output_meta: {
      germlineBam: "BAM file of germline hits (empty if outputGermlineEvents is false)",
      somaticBam: "BAM file of somatic hits",
      kmers: "Called kmers"
    }
   }

  call runNovoBreak {
    input:
      normalBam = normalBam,
      normalBai = normalBai,
      tumorBam = tumorBam,
      tumorBai = tumorBai,
      referenceModule = referenceModule,
      referenceFasta = referenceFasta,
      outputGermlineEvents = outputGermlineEvents,
      kmerSize = kmerSize,
      kmerMin = kmerMin
  }

  output {
    File germlineBam = runNovoBreak.germlineBam
    File somaticBam = runNovoBreak.somaticBam
    File kmers = runNovoBreak.kmers
  }
}

task runNovoBreak {
  input {
    File normalBam
    File normalBai
    File tumorBam
    File tumorBai
    String referenceModule
    String referenceFasta
    Boolean outputGermlineEvents
    Int? kmerSize
    Int? kmerMin
    String novoBreakModule = "novobreak/1.13"
    Int threads = 6
    Int jobMemory = 40
    Int timeout = 6
  }

  parameter_meta {
    normalBam: "Normal BAM file"
    normalBai: "Index file for normalBam"
    tumorBam: "Tumor BAM file"
    tumorBai: "Index file for tumorBam"
    referenceModule: "Modulator module that loads the reference fasta data"
    referenceFasta: "Reference file in fasta format"
    outputGermlineEvents: "Output germline events (false by default)"
    kmerSize: "Kmer size, <=31 [31]"
    kmerMin: "Minimum kmer count regarded as novo kmers [3]"
    novoBreakModule: "novoBreak module to load in modulator"
    jobMemory: "Memory (GB) allocated for this job"
    threads: "Requested CPU threads"
    timeout: "Number of hours before task timeout"
  }

  String modules = "~{novoBreakModule} ~{referenceModule}"
  String flagOutputGermlineEvents = if outputGermlineEvents then "-g 1" else ""
  String flagKmerSize = if defined(kmerSize) then "-k ~{kmerSize}" else ""
  String flagKmerMin =  if defined(kmerMin) then "-m ~{kmerMin}" else ""

  command <<<
  set -euo pipefail

  novoBreak \
    -i ~{tumorBam} \
    -c ~{normalBam} \
    -r ~{referenceFasta} \
    ~{flagOutputGermlineEvents} \
    ~{flagKmerSize} \
    ~{flagKmerMin} \
    -o kmer.txt

  >>>

  output {
    File somaticBam = "somaticreads.bam"
    File germlineBam = "germlinereads.bam"
    File kmers = "kmer.txt"
  }

  meta {
    output_meta: {
      germlineBam: "BAM file of germline hits (empty if outputGermlineEvents is false)",
      somaticBam: "BAM file of somatic hits",
      kmers: "Called kmers"
    }
  }

  runtime {
    modules: "~{modules}"
    memory:  "~{jobMemory} GB"
    cpu:     "~{threads}"
    timeout: "~{timeout}"
  }
}
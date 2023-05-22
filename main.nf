#!/usr/bin/env nextflow

// Using DSL-2
nextflow.enable.dsl=2

// All of the default parameters are being set in `nextflow.config`

// Import sub-workflows
include { validate_manifest } from './modules/manifest'


// Function which prints help message text
def helpMessage() {
    log.info"""
Usage:

nextflow run pranavmuthu/masSeq-nextflow <ARGUMENTS>

Required Arguments:

  Input Data:
  --data_dir            Directory containing folders with segmented.bam files {/fh/fast/furlan_s/SR/ngs/pacbio/230501_Sami}

  Reference Data:
  --ref_dir             Directory containing PacBio long read reference data {/fh/fast/furlan_s/grp/refs/long_read_refs/pacbio}

  Output Location:
  --out_dir             Directory to write output files into {/fh/scratch/delete90/furlan_s/targ_reseq/230501_Sami}
  
  Other Required Data:
  --primers_5p          FastA primers file {$ref_dir/5p_10x_primers.fasta}
  --cbc_include         {$ref_dir/737K-august-2016.txt}
  --hg38                FastA genome to align to {/fh/fast/furlan_s/grp/refs/long_read_refs/Human_hg38_Gencode_v39/human_GRCh38_no_alt_analysis_set.fasta}
  --annotation          GTF annotation file {/fh/fast/furlan_s/grp/refs/long_read_refs/Human_hg38_Gencode_v39/gencode.v39.annotation.sorted.gtf}
  --pA                  PolyA sequences file {/fh/fast/furlan_s/grp/refs/long_read_refs/Human_hg38_Gencode_v39/polyA.list.txt}
  --cage                Bed file for Cage Peaks {/fh/fast/furlan_s/grp/refs/long_read_refs/Human_hg38_Gencode_v39/refTSS_v3.3_human_coordinate.hg38.sorted.bed}
  --threads             # of threads needed(10)
  
    """.stripIndent()
}


// Main workflow
workflow {

    // Show help message if the user specifies the --help flag at runtime
    // or if any required params are not provided
    if ( params.help || params.output_folder == false || params.genome_fasta == false ){
        // Invoke the function above which prints the help message
        helpMessage()
        // Exit out and do not run anything else
        exit 1
    }

    // The user should specify --fastq_folder OR --manifest, but not both
    if ( params.fastq_folder && params.manifest ){
        log.info"""
        User may specify --fastq_folder OR --manifest, but not both
        """.stripIndent()
        // Exit out and do not run anything else
        exit 1
    }
    if ( ! params.fastq_folder && ! params.manifest ){
        log.info"""
        User must specify --fastq_folder or --manifest.
        Run with --help for more details.
        """.stripIndent()
        // Exit out and do not run anything else
        exit 1
    }

    // If the --fastq_folder input option was provided
    if ( params.fastq_folder ){

        // Make a channel with the input FASTQ read pairs from the --fastq_folder
        // After calling `fromFilePairs`, the structure must be changed from
        // [specimen, [R1, R2]]
        // to
        // [specimen, R1, R2]
        // with the map{} expression

        // Define the pattern which will be used to find the FASTQ files
        fastq_pattern = "${params.fastq_folder}/*_R{1,2}*fastq.gz"

        // Set up a channel from the pairs of files found with that pattern
        fastq_ch = Channel
            .fromFilePairs(fastq_pattern)
            .ifEmpty { error "No files found matching the pattern ${fastq_pattern}" }
            .map{
                [it[0], it[1][0], it[1][1]]
            }

    // Otherwise, they must have provided --manifest
    } else {

        // Parse the CSV file which was provided by the user
        // and make sure that it has the expected set of columns
        // (this is the most common user error with manifest files)
        validate_manifest(
            Channel.fromPath(params.manifest)
        )

        // Make a channel which includes
        // The sample name from the first column
        // The file which is referenced in the R1 column
        // The file which is referenced in the R2 column
        fastq_ch = validate_manifest
            .out
            .splitCsv(header: true)
            .flatten()
            .map {row -> [row.sample, file(row.R1), file(row.R2)]}

        // The code above is an example of how we can take a flat file
        // (the manifest), split it into each row, and then parse
        // the location of the files which are pointed to by their
        // paths in two of the columns (but not the first one, which
        // is just a string)

    }

    // Perform quality trimming on the input 
    quality_wf(
        fastq_ch
    )
    // output:
    //   reads:
    //     tuple val(specimen), path(read_1), path(read_2)

    // Align the quality-trimmed reads to the reference genome
    align_wf(
        quality_wf.out.reads,
        file(params.genome_fasta)
    )
    // output:
    //   bam:
    //     tuple val(specimen), path(bam)

}

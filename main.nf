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
    if ( params.help || params.ref_dir == false || params.data_dir = false || params.out_dir == false || params.primers_5p == false || params.cbc_include == false || params.hg38 == false || params.annotation == false || params.pA == false || params.cage == false || params.threads == false ){
        // Invoke the function above which prints the help message
        helpMessage()
        // Exit out and do not run anything else
        exit 1
    }

    // Run the workflow if all parameters are given
    else {
    
    }

   

}

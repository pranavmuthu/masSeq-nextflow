#!/usr/bin/env nextflow

include { lima } from './modules/lima'
// might need to change to -> include { lima } from './lima'

workflow masseq_wf {

    // Make a channel which contains all of the (segmented) BAMs
    Channel
        .fromPath(
            "${params.data_dir}/*",
            checkIfExists: true,
            type: 'dir'
        )
        .set { folder_dir }

   // Run lima on each of the BAMs within the data_dir
   lima(bam_ch)
   // To use the output produced by lima, reference:
   // lima.out.lima_outputs

}
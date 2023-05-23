#!/bin/bash

set -euo pipefail

echo "Checking for segmented.bam in ${input_folder}"
if [ -s "${input_folder}/segmented.bam" ]; then

    echo "Running lima on ${input_folder}/segmented.bam"

    mkdir -p output

    echo "Running Lima, Tag, Refine, Correct, Sort, BCstats, and dedupe for all input bams"
    lima \
        --log-level INFO \
        --log-file ${input_folder}.lima.log \
        --isoseq \
        -j ${task.cpus} \
        "${input_folder}/segmented.bam" \
        "${params.primers_5p}" \
        "output/${input_folder}.bam"

    echo "DONE"

fi

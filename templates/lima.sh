#!/bin/bash

set -euo pipefail

echo "Creating and moving to output folder"
mkdir -p $out_dir
cd $out_dir

echo "Running Lima, Tag, Refine, Correct, Sort, BCstats, and dedupe for all input bams"
for ibam in $data_dir/Sami*/segmented.bam; do
    export bam=$ibam
    in_dir=`dirname $bam`
    prefix=$in_dir/`basename $bam | cut -d'.' -f1`
    export prefix=${prefix/#"${data_dir}/"}
    export out_subdir=`dirname $prefix`
    mkdir -p $out_subdir
    
    sbatch -n 1 -c 30 -p campus-new -M gizmo --mem-per-cpu=21000MB --wrap='lima \
        --log-level INFO \
        --log-file $out_subdir/lima.log \
        --isoseq \
        -j $threads \
        $bam \
        $primers_5p \
        $prefix.bam
done

echo "DONE"

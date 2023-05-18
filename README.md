# masSeq-nextflow
This workflow is designed to help streamline MDS MAS-Seq PacBio long read data analysis using the Nextflow workflow manager. Segmented BAMs are passed into the pre-processing steps(lima, tag, refine, and correct --> mergebams, sort, index) to then branch off into the isoform steps(dedup align, collapse sort, classify filter, and make-seurat) to output a mtx and into the variant calling steps(align, [input csv] subset, variant caller{deepvariant/clair3/GATK}, clinvar, and mutcaller) to output a mtx. 

![Workflow](masSEQ-nextflow/pipeline.pdf)

[embed]https://github.com/pranavmuthu/masSeq-nextflow/blob/main/pipeline.pdf[/embed]

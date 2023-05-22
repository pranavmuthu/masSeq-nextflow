// Run Lima
process lima {
    container "${params.container__fastqc}" #change to a container with lima installed
    
    input:
    tuple val(specimen), path(R1), path(R2) ??

    output:
    path "fastqc/*.zip", emit: zip ?? 
    path "fastqc/*.html", emit: html ??

    script:
    template 'lima.sh'

}

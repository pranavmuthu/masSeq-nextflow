// Run Lima
process lima {
    container "${params.container__lima}"
    publishDir "${params.out_dir}/${input_folder}/", mode: 'copy', overwrite: true, pattern: "*.lima.log"
    
    input:
    path input_folder
    
    output:
    path "${input_folder}.lima.log", emit: log
    path "output/*", emit: lima_outputs

    script:
    template 'lima.sh'

}

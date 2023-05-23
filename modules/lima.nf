// Run Lima
process lima {
    container "${params.container__lima}" 
    
    input:
    

    output:
   

    script:
    template 'lima.sh'

}

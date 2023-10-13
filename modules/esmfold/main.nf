process ESMFOLD_INFERENCE {
    publishDir "${params.resultsDir}/predicted/", mode: 'copy', pattern: "*.pdb"

    input: 
        path('protein.fasta')
    output:
        path("*.pdb")

    shell:
    """
    esmfold-inference.py -i protein.fasta -o . ${params.esmfold.args}
    """
    
    stub:
    """
    touch protein{1,2}.pdb
    """
}
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

process ESMFOLD_SCORE_LOGLIK {
    publishDir "${params.resultsDir}/", mode: 'copy', pattern: "report-score-loglik.csv"

    input: 
        path('protein.fasta')
    output:
        path("report-score-loglik.csv")

    shell:
    """
    curl https://files.rcsb.org/download/${params.esmfold.score.wildtype}.pdb -o ref.pdb && \
    esmfold-score-loglik.py ref.pdb protein.fasta --outpath report-score-loglik.csv
    """
    
    stub:
    """
    touch report-score-loglik.csv
    """
}
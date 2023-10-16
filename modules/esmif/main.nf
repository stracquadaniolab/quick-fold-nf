process ESMIF_SCORE_LOGLIK {
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
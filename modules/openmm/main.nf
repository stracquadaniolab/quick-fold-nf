process OPENMM_PDB_RELAX {
    publishDir "${params.resultsDir}/relaxed/", pattern: "protein_relaxed.*", mode: 'copy', saveAs: { filename -> "${protein_id}.pdb" }

    input: 
        tuple val(protein_id), path('protein_predicted.pdb')
    output:
        tuple val(protein_id), path("protein_relaxed.pdb")

    shell:
    """
    openmm-pdb-relax.py ${params.openmm.pdb.relax.args} protein_predicted.pdb protein_relaxed.pdb
    """
    
    stub:
    """
    touch protein_relaxed.pdb
    """
}
include { ESMFOLD_INFERENCE } from './modules/esmfold'
include { OPENMM_PDB_RELAX } from './modules/openmm'

// printing message of the day
motd = """
--------------------------------------------------------------------------
quick-fold-nf ($workflow.manifest.version)
--------------------------------------------------------------------------
Session ID                : $workflow.sessionId
--------------------------------------------------------------------------
Input/output options
--------------------------------------------------------------------------
Query file                : $params.inputFile
Results directory         : $params.resultsDir
--------------------------------------------------------------------------
Analysis options
--------------------------------------------------------------------------
ESMFold args              : $params.esmfold.args        
OpenMM PDB relax          : $params.openmm.pdb.relax.args       
--------------------------------------------------------------------------
Environment information
--------------------------------------------------------------------------
Container                 : $workflow.container
Config files              : $workflow.configFiles
Project dir               : $workflow.projectDir
Work dir                  : $workflow.workDir
Launch dir                : $workflow.launchDir
Command line              : $workflow.commandLine
Repository                : $workflow.repository
CommitID                  : $workflow.commitId
Revision                  : $workflow.revision
--------------------------------------------------------------------------
"""

log.info motd

process TELEMETRY {

    publishDir "${params.resultsDir}", mode: 'copy', overwrite: 'yes'

	output:
        path('info.txt')

    shell:
    """
    echo '${motd}' > info.txt
    """

    stub: 
    """
    touch info.txt
    """
}

workflow QUICK_FOLD {
    TELEMETRY()
    channel.fromPath("${params.inputFile}") \
    | ESMFOLD_INFERENCE \
    | flatten \
    | map{ it -> tuple(it.simpleName, it) } \
    | OPENMM_PDB_RELAX
}

workflow{

    QUICK_FOLD()

}

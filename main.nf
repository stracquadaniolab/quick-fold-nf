include { ESMFOLD_INFERENCE } from './modules/esmfold'
include { OPENMM_PDB_RELAX } from './modules/openmm'

workflow QUICK_FOLD {
    channel.fromPath("${params.inputFile}") \
    | ESMFOLD_INFERENCE \
    | flatten \
    | map{ it -> tuple(it.simpleName, it) } \
    | OPENMM_PDB_RELAX
}

workflow{

    QUICK_FOLD()

}

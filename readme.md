# quick-fold-nf

![](https://img.shields.io/badge/current_version-0.0.0-blue)
![](https://github.com/stracquadaniolab/quick-fold-nf/workflows/build/badge.svg)
## Overview
A Nextflow workflow for protein structure prediction.

## Configuration

- `inputFile`: FASTA file with one or more sequences (required)
- `resultsDir`: directory where to store the results (default: results/yyyy.MM.dd-HH.mm.ss-quick-fold)
- `esmfold.args`: options passed to ESMFold  (default: "--num-recycles 4 --chunk-size 16")
- `openmm.pdb.relax.args`: options passed to OpenMM PDB relaxation (default: "--fix-pdb")

## Running the workflow

### Install or update the workflow

```bash
nextflow pull stracquadaniolab/quick-fold-nf
```

### Run the analysis

```bash
nextflow run stracquadaniolab/quick-fold-nf
```

## Results

- `$resultsDir/predicted/<seqid>.pdb`: PDB file for each sequence in input as predicted by ESMFold.
- `$resultsDir/relaxed/<seqid>.pdb`: PDB files after energy minimization.

## Authors

- Giovanni Stracquadanio

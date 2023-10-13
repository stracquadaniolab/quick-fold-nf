#!/usr/bin/env python
"""openmm-pdb-relax

Relax protein structures predicted by ESMfold using Amber14

Usage:
  openmm-pdb-relax.py [--fix-pdb] [--no-restraints] [--max-iterations=<iter_max>] <in_pdb> <out_pdb>

Options:
  --fix-pdb                     Fix PDB before. 
  --no-restraints               Allow movement of all atoms
  --max-iterations=<iter_max>   Max number of energy minimization iterations [default: 100]
  -h --help                     Show this screen.
  --version                     Show version.

"""
import logging
from docopt import docopt
from openmm import *
from openmm.app import *
from openmm.app.modeller import *
from pdbfixer import PDBFixer
from sys import stdout


def get_pdb(filename: str, fix_pdb: bool):
    pdb = None
    if fix_pdb: 
        logging.info("Fixing PDB file")
        pdb = PDBFixer(filename=filename)
        pdb.findMissingResidues()
        pdb.findNonstandardResidues()
        pdb.replaceNonstandardResidues()
        pdb.removeHeterogens(True)
        pdb.findMissingAtoms()
        pdb.addMissingAtoms()
        pdb.addMissingHydrogens(7.0)
    else:
        pdb = PDBFile(filename)
    return pdb

def setup_forcefield():
    forcefield = ForceField("amber14-all.xml", "amber14/tip3pfb.xml")
    return forcefield

def setup_system(pdb, forcefield, no_restraints: bool):
    system = forcefield.createSystem(
        pdb.topology,
        nonbondedMethod=NoCutoff
    )

    if not no_restraints:
        logging.info("Using restraints on CA atoms")
        restraint = CustomExternalForce("0.5 * k * ((x-x0)^2 + (y-y0)^2 + (z-z0)^2)")
        restraint.addGlobalParameter("k", 100.0 * unit.kilojoules_per_mole / unit.nanometer)
        restraint.addPerParticleParameter("x0")
        restraint.addPerParticleParameter("y0")
        restraint.addPerParticleParameter("z0")
        system.addForce(restraint)

        # apply restraints only to CA atoms
        for atom in pdb.topology.atoms():
            if atom.name == "CA":
                restraint.addParticle(atom.index, pdb.positions[atom.index])

        return system



def setup_simulation(pdb, system):
    integrator = LangevinMiddleIntegrator(
        300 * unit.kelvin, 1 / unit.picosecond, 0.004 * unit.picoseconds
    )

    # setup simulation
    simulation = Simulation(pdb.topology, system, integrator)
    simulation.context.setPositions(pdb.positions)
    return simulation


def main():
    arguments = docopt(__doc__, version='openmm-pdb-relax.py')

    # read pdb file
    pdb = get_pdb(arguments['<in_pdb>'], arguments['--fix-pdb'])

    # setup forcefield and system
    forcefield = setup_forcefield()
    system = setup_system(pdb, forcefield, arguments['--no-restraints'])
    simulation = setup_simulation(pdb, system)

    # logging protein initial energy
    init_state = simulation.context.getState(getEnergy=True, getPositions=True)
    logging.info(
        "Starting potential energy = %.3f kcal/mol"
        % init_state.getPotentialEnergy().value_in_unit(unit.kilocalories_per_mole)
    )

    # minimize energy
    simulation.minimizeEnergy()

    # record final energy state
    final_state = simulation.context.getState(getEnergy=True, getPositions=True)
    
    # logging protein final energy
    logging.info(
        "Minimum potential energy = %.3f kcal/mol"
        % final_state.getPotentialEnergy().value_in_unit(unit.kilocalories_per_mole)
    )

    PDBFile.writeFile(
        simulation.topology, final_state.getPositions(), open(arguments['<out_pdb>'], "w")
    )

if __name__ == '__main__':
    logging.getLogger().setLevel(logging.INFO)
    main()
#!/bin/bash -l

#PBS -N nalu_build_intel
#PBS -l nodes=1:ppn=24,walltime=4:00:00
#PBS -A windFlowModeling
#PBS -q batch
#PBS -j oe
#PBS -W umask=002

#Script for installing Nalu on Merlin using Spack with Intel compiler

set -e

module purge
module load GCCcore/4.9.2

export TMPDIR=/dev/shm

# The intel.cfg sets up the -xlinker rpath for the intel compiler's own libraries
for i in ICCCFG ICPCCFG IFORTCFG
do
  export $i=${SPACK_ROOT}/etc/spack/intel.cfg
done

# Get general preferred Nalu constraints from a single location
source ../spack_config/shared_constraints.sh

(set -x; spack install nalu %intel@17.0.2 ^${TRILINOS}@develop ${GENERAL_CONSTRAINTS})

(set +e; set -x; rm -rf /dev/shm/*)

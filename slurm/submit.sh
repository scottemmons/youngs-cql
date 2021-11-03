#!/bin/bash

SEEDS=10
ENVS="antmaze-umaze-v2;antmaze-umaze-diverse-v2;antmaze-medium-diverse-v2;antmaze-medium-play-v2;antmaze-large-diverse-v2;antmaze-large-play-v2"
SCRATCH="/global/scratch/users/emmons"

mkdir logs/out/ -p
mkdir logs/err/ -p

arrENVS=(${ENVS//;/ })
NUM_ENVS=${#arrENVS[@]}
STEPS=$((SEEDS*NUM_ENVS))

sbatch --export=ENVS=$ENVS,SEEDS=$SEEDS,OUTDIR=$OUTDIR,ERRDIR=$ERRDIR,SCRATCH=$SCRATCH --array=1-${STEPS} sbatch.sh

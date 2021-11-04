#!/usr/bin/env bash

ENVS="antmaze-umaze-v2;antmaze-umaze-diverse-v2;antmaze-medium-play-v2;antmaze-medium-diverse-v2;antmaze-large-play-v2;antmaze-large-diverse-v2"
SCRATCH="/global/scratch/users/emmons"

mkdir logs/out/ -p
mkdir logs/err/ -p
mkdir work -p

arrENVS=(${ENVS//;/ })
NUM_ENVS=${#arrENVS[@]}

sbatch --export=ENVS=$ENVS,SCRATCH=$SCRATCH --array=1-${NUM_ENVS} sbatch.sh

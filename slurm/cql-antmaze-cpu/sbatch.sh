#!/usr/bin/env bash
#SBATCH --job-name=cql-antmaze
#SBATCH --open-mode=append
#SBATCH --output=logs/out/%A_%a.txt
#SBATCH --error=logs/err/%A_%a.txt
#SBATCH --mem=0
#SBATCH --account=co_rail
#SBATCH --partition=savio3
#SBATCH --ntasks-per-node=8
#SBATCH --nodes=1
#SBATCH --time=40:00:00

module load intel openmpi

NUM_SEEDS=6

ENV_ID=$((SLURM_ARRAY_TASK_ID-1))

arrENVS=(${ENVS//;/ })
ENV_NAME=${arrENVS[$ENV_ID]}

MAX_STEPS=1000
if [[ $ENV_NAME == *"umaze"* ]]; then
    MAX_STEPS=700
fi

ht_helper.sh -t taskfile.sh -w work -r $NUM_SEEDS -e ENV_NAME=$ENV_NAME,MAX_STEPS=$MAX_STEPS

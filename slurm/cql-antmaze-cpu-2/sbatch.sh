#!/usr/bin/env bash
#SBATCH --open-mode=append
#SBATCH --mem=0
#SBATCH --account=co_rail
#SBATCH --nodes=1
#SBATCH --time=23:59:59

module load gcc openmpi

FIRST_TASK=$((SLURM_ARRAY_TASK_ID * SLURM_NTASKS_PER_NODE))
FINAL_TASK=$(($(wc -l < taskfile.sh) - 1))
LAST_TASK=$(((SLURM_ARRAY_TASK_ID + 1) * SLURM_NTASKS_PER_NODE - 1))
LAST_TASK=$((FINAL_TASK < LAST_TASK ? FINAL_TASK : LAST_TASK))

ht_helper.sh -t taskfile.sh -w work -i $FIRST_TASK-$LAST_TASK,$FINAL_TASK

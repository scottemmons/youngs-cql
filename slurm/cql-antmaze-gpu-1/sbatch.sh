#!/usr/bin/env bash
#SBATCH --gres=gpu:TITAN:1
#SBATCH --mem=44G
#SBATCH --account=co_rail
#SBATCH --partition=savio3_gpu
#SBATCH --qos=rail_gpu3_normal
#SBATCH --time=6-23:59:59
#SBATCH --open-mode=append

module load gcc openmpi

FIRST_TASK=$((SLURM_ARRAY_TASK_ID * SLURM_NTASKS))
LAST_TASK=$(((SLURM_ARRAY_TASK_ID + 1) * SLURM_NTASKS - 1))
FINAL_TASK=$(($(wc -l < taskfile.sh) - 1))
LAST_TASK=$((FINAL_TASK < LAST_TASK ? FINAL_TASK : LAST_TASK))

ht_helper.sh -t taskfile.sh -w work -i $FIRST_TASK-$LAST_TASK,$FINAL_TASK

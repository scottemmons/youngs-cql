#!/usr/bin/env bash

JOB_NAME="cql-locomotion-gpu-1"
CPUS_PER_GPU=4  # this is the number of cpus per gpu on the savio3_gpu titan nodes
TASKS_PER_GPU=4  # set the number of tasks per gpu

mkdir logs/out/ -p
mkdir logs/err/ -p
mkdir work -p

CPUS_PER_TASK=$((CPUS_PER_GPU / TASKS_PER_GPU))
TOTAL_TASKS=$(($(wc -l < taskfile.sh) - 1))
NUM_TASKS=$(((TOTAL_TASKS+TASKS_PER_GPU-1) / TASKS_PER_GPU))  # ceiling division

sbatch --array=0-$(($NUM_TASKS-1)) --ntasks=${TASKS_PER_GPU} --cpus-per-task=${CPUS_PER_TASK} --job-name=${JOB_NAME} --output=logs/out/%A_%a.out --error=logs/err/%A_%a.err sbatch.sh
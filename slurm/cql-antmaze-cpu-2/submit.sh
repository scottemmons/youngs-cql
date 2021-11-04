#!/usr/bin/env bash

JOB_NAME="cql-antmaze"
PARTITION="savio2"
CPUS_PER_NODE=24  # this is how many cpu cores are on each savio2 node
TASKS_PER_NODE=2  # set the number of tasks per node

mkdir logs/out/ -p
mkdir logs/err/ -p
mkdir work -p

CPUS_PER_TASK=$((CPUS_PER_NODE / TASKS_PER_NODE))
TOTAL_TASKS=$(($(wc -l < taskfile.sh) - 1))
NUM_TASKS=$(((TOTAL_TASKS+TASKS_PER_NODE-1) / TASKS_PER_NODE))  # ceiling division

sbatch --array=0-$(($NUM_TASKS-1)) --ntasks-per-node=${TASKS_PER_NODE} --cpus-per-task=${CPUS_PER_TASK} --job-name=${JOB_NAME} --partition=${PARTITION} --output=logs/out/%A_%a.out --error=logs/err/%A_%a.err sbatch.sh 

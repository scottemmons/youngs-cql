#!/usr/bin/env bash

declare -a ENVS=("kitchen-mixed-v0" "kitchen-partial-v0" "kitchen-complete-v0")
MAX_TRAJ_LENGTH=280
NUM_SEEDS=5

for ENV in "${ENVS[@]}"; do
    for SEED in $(seq 0 $((NUM_SEEDS-1))); do
        python -m SimpleSAC.conservative_sac_main \
            --n_epochs 1000 \
            --eval_period 100 \
            --eval_n_trajs 100 \
            --policy_arch '256-256-256' \
            --qf_arch '256-256-256' \
            --cql.policy_lr 3e-5 \
            --cql.cql_lagrange \
            --logging.output_dir './experiment_output' \
            --device='cuda' \
            --logging.project 'cql' \
            --logging.online \
            --env $ENV \
            --max_traj_length $MAX_TRAJ_LENGTH \
            --seed $SEED
    done
done

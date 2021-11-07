#!/usr/bin/env bash

declare -a ENVS=("antmaze-umaze-v2" "antmaze-umaze-diverse-v2" "antmaze-medium-diverse-v2" "antmaze-medium-play-v2" "antmaze-large-diverse-v2" "antmaze-large-play-v2")
NUM_SEEDS=5

for ENV in "${ENVS[@]}"; do
    for SEED in $(seq 0 $((NUM_SEEDS-1))); do
        MAX_TRAJ_LENGTH=1000
        if [[ $ENV == *"umaze"* ]]; then
            MAX_TRAJ_LENGTH=700
        fi
        python -m SimpleSAC.conservative_sac_main \
            --n_epochs 1000 \
            --eval_period 100 \
            --eval_n_trajs 100 \
            --policy_arch '256-256-256' \
            --qf_arch '256-256-256' \
            --cql.policy_lr 1e-4 \
            --cql.cql_lagrange \
            --cql.cql_target_action_gap 5.0 \
            --cql.cql_min_q_weight 5.0 \
            --logging.output_dir './experiment_output' \
            --device='cuda' \
            --logging.project 'cql' \
            --logging.online \
            --env $ENV \
            --max_traj_length $MAX_TRAJ_LENGTH \
            --seed $SEED
    done
done

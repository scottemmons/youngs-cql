#!/bin/bash
#SBATCH --job-name=cql-antmaze
#SBATCH --open-mode=append
#SBATCH --output=logs/out/%A_%a.txt
#SBATCH --error=logs/err/%A_%a.txt
#SBATCH --time=23:59:59
#SBATCH --mem-per-cpu=2G
#SBATCH --cpus-per-task=4
#SBATCH --account=co_rail
#SBATCH --partition=savio3

arrENVS=(${ENVS//;/ })

SEED_ID=$(((SLURM_ARRAY_TASK_ID-1)/${#arrENVS[@]}))
ENV_ID=$(((SLURM_ARRAY_TASK_ID-1)%${#arrENVS[@]}))

singularity exec --nv -B /usr/lib64 -B /var/lib/dcv-gl --overlay $SCRATCH/singularity/overlay-50G-10M.ext3:ro $SCRATCH/singularity/cuda10.2-cudnn7-devel-ubuntu18.04.sif /bin/bash -c "

source /ext3/env.sh
conda activate SimpleSAC
cd $SCRATCH/youngs-cql
export PYTHONPATH="$PYTHONPATH:$(pwd)"

python -m SimpleSAC.conservative_sac_main --eval_period 100 --eval_n_trajs 100 --cql.policy_lr 1e-4 --cql.cql_target_action_gap 5.0 --cql.cql_min_q_weight 5.0 --env '${arrENVS[$ENV_ID]}' --seed=${SEED_ID} --logging.output_dir './experiment_output' --device='cpu' --logging.project 'cql' --logging.online
"

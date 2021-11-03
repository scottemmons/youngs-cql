#!/bin/bash
#SBATCH --job-name=cql-antmaze
#SBATCH --open-mode=append
#SBATCH --output=logs/out/%x_%j.txt
#SBATCH --error=logs/err/%x_%j.txt
#SBATCH --time=20:00:00
#SBATCH --mem=16G
#SBATCH --cpus-per-task=4
#SBATCH --gres=gpu:GTX2080TI:1
#SBATCH --account=co_rail
#SBATCH --partition=savio3_gpu
#SBATCH --qos=savio_lowprio

arrENVS=(${ENVS//;/ })

SEED_ID=$(((SLURM_ARRAY_TASK_ID-1)/${#arrENVS[@]}))
ENV_ID=$(((SLURM_ARRAY_TASK_ID-1)%${#arrENVS[@]}))

singularity exec --nv -B /usr/lib64 -B /var/lib/dcv-gl --overlay $SCRATCH/singularity/overlay-50G-10M.ext3:ro $SCRATCH/singularity/cuda10.2-cudnn7-devel-ubuntu18.04.sif /bin/bash -c "

source /ext3/env.sh
conda activate CQL
export PYTHONPATH="$PYTHONPATH:$(pwd)"

cd $SCRATCH/youngs-cql
python -m SimpleSAC.conservative_sac_main --eval_period 100 --eval_n_trajs 100 --policy_lr 1e-4 --cql_target_action_gap 5.0 --cql_min_q_weight 5.0 --env '${arrENVS[$ENV_ID]}' --seed=${SEED_ID} --output_dir './experiment_output' --device='cuda'
"

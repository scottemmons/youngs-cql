env_and_steps = [
    "--env antmaze-umaze-v2 --max_traj_length 700",
    "--env antmaze-umaze-diverse-v2 --max_traj_length 700",
    "--env antmaze-medium-play-v2 --max_traj_length 1000",
    "--env antmaze-medium-diverse-v2 --max_traj_length 1000",
    "--env antmaze-large-play-v2 --max_traj_length 1000",
    "--env antmaze-large-diverse-v2 --max_traj_length 1000",
]
num_seeds = 5
filename = "taskfile.sh"


def write_to_file(lines, outfile=filename, mode="w"):
    with open(outfile, mode) as f:
        f.writelines(line + "\n" for line in lines)


def main():
    lines = []
    command_head = "singularity exec --nv -B /usr/lib64 -B /var/lib/dcv-gl --overlay /global/scratch/users/emmons/singularity/overlay-50G-10M.ext3:ro /global/scratch/users/emmons/singularity/cuda10.2-cudnn7-devel-ubuntu18.04.sif /bin/bash -c \"source /ext3/env.sh; conda activate SimpleSAC; cd /global/scratch/users/emmons/youngs-cql; export PYTHONPATH=\\\"$PYTHONPATH:$(pwd)\\\"; python -m SimpleSAC.conservative_sac_main --n_epochs 1000 --eval_period 100 --eval_n_trajs 100 --policy_arch '256-256-256' --qf_arch '256-256-256' --cql.policy_lr 1e-4 --cql.cql_lagrange --cql.cql_target_action_gap 5.0 --cql.cql_min_q_weight 5.0 --logging.output_dir './experiment_output' --device='cpu' --logging.project 'cql' --logging.online"
    for seed in range(num_seeds):
        for env_and_step in env_and_steps:
            command = command_head + " --seed " + str(seed) + " " + env_and_step
            lines.append(command)

    write_to_file(lines)
    write_to_file(["sleep 600"], mode="a")


if __name__ == "__main__":
    main()

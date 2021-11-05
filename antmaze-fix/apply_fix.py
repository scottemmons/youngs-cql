import os

import d4rl
import gym
import h5py
from tqdm import tqdm

urls = {
    "antmaze-umaze-v0": "http://rail.eecs.berkeley.edu/datasets/offline_rl/ant_maze_new/Ant_maze_u-maze_noisy_multistart_False_multigoal_False_sparse.hdf5",
    "antmaze-umaze-diverse-v0": "http://rail.eecs.berkeley.edu/datasets/offline_rl/ant_maze_new/Ant_maze_u-maze_noisy_multistart_True_multigoal_True_sparse.hdf5",
    "antmaze-medium-play-v0": "http://rail.eecs.berkeley.edu/datasets/offline_rl/ant_maze_new/Ant_maze_big-maze_noisy_multistart_True_multigoal_False_sparse.hdf5",
    "antmaze-medium-diverse-v0": "http://rail.eecs.berkeley.edu/datasets/offline_rl/ant_maze_new/Ant_maze_big-maze_noisy_multistart_True_multigoal_True_sparse.hdf5",
    "antmaze-large-play-v0": "http://rail.eecs.berkeley.edu/datasets/offline_rl/ant_maze_new/Ant_maze_hardest-maze_noisy_multistart_True_multigoal_False_sparse.hdf5",
    "antmaze-large-diverse-v0": "http://rail.eecs.berkeley.edu/datasets/offline_rl/ant_maze_new/Ant_maze_hardest-maze_noisy_multistart_True_multigoal_True_sparse.hdf5",
}


def get_keys(h5file):
    keys = []

    def visitor(name, item):
        if isinstance(item, h5py.Dataset):
            keys.append(name)

    h5file.visititems(visitor)
    return keys


def get_dict(filename):
    data_dict = {}
    with h5py.File(filename, "r") as dataset_file:
        print(dataset_file)
        for k in tqdm(get_keys(dataset_file), desc="load datafile"):
            try:  # first try loading as an array
                data_dict[k] = dataset_file[k][:]
            except ValueError as e:  # try loading as a scalar
                data_dict[k] = dataset_file[k][()]
    return data_dict


if __name__ == "__main__":
    dataset_path = os.path.expanduser("~/.d4rl/datasets")
    for env_name, url in urls.items():
        gym.make(env_name).get_dataset()
        filename = os.path.join(dataset_path, url.split("/")[-1])
        time_limit = 701 if env_name == "antmaze-umaze-v0" else 1001
        data_dict = get_dict(filename)
        data_dict["timeouts"].fill(False)
        data_dict["timeouts"][time_limit - 1 :: time_limit] = True
        dataset = h5py.File(filename.replace("sparse", "sparse_fixed"), "w")
        for k, v in data_dict.items():
            dataset.create_dataset(k, data=v, compression="gzip")
        dataset.close()

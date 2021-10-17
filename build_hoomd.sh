#! /bin/bash

name_env="EnvName"
anaconda_path=$HOME/anaconda3
build_path="build"


conda create -y -n $name_env python=3.7
source ${anaconda_path}/etc/profile.d/conda.sh
conda activate $name_env
python3 hoomd-blue/install-prereq-headers.py
conda install -y numpy

cmake -B $build_path -S hoomd-blue -GNinja
cmake $build_path -DENABLE_GPU=on -DCMAKE_C_COMPILER=gcc-8 -DCMAKE_C_COMPILER_AR=gcc-ar-8 -DCMAKE_C_COMPILER_RANLIB=gcc-ranlib-8 -DCMAKE_CXX_COMPILER=g++-8

cmake --build $build_path
cmake --install $build_path

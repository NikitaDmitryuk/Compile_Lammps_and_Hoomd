#! /bin/bash

name_env="Yukawa"
anaconda_path=$HOME/anaconda3
build_path="build"

conda remove -y --name $name_env --all
conda create -y -n $name_env python=3.8
source ${anaconda_path}/etc/profile.d/conda.sh
conda activate $name_env
conda install -y numpy

cmake --build $build_path --target clean
cmake -B $build_path -S hoomd-v2.9.6 -GNinja
cmake $build_path\
    -DCMAKE_INSTALL_PREFIX=`python3 -c "import site; print(site.getsitepackages()[0])"`\
    -DCMAKE_CXX_FLAGS=-march=native\
    -DCMAKE_C_FLAGS=-march=native\
    -DCMAKE_CXX_COMPILER=/usr/bin/c++-8\ #?
    -DENABLE_CUDA=ON

cmake $build_path -DENABLE_CUDA=ON

cmake --build $build_path
cmake --install $build_path

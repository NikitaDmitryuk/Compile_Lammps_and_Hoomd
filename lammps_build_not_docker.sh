#!/bin/bash

cd ./lammps
mkdir build
cd build

make clean

cmake -D CMAKE_INSTALL_PREFIX=/opt\
    -D CMAKE_LIBRARY_PATH=/opt/cuda/lib64/stubs\
    -D BIN2C=/opt/cuda/bin/bin2c\
    -D LAMMPS_MACHINE=g++_openmpi\
    -D PKG_GPU=on\
    -D GPU_API=cuda\
    -D GPU_ARCH=sm_61\
    ../cmake

make -j$(nproc)

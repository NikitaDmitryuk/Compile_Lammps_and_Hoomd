#!/bin/bash
# GTX1060: sm_61
# GTX Titan Black: sm_35
gpu_arch="sm_61"

cmake -B build -S lammps/cmake -GNinja

cmake build\
    -D CMAKE_INSTALL_PREFIX=/opt\
    -D CMAKE_LIBRARY_PATH=/opt/cuda/lib64/stubs\
    -D BIN2C=/opt/cuda/bin/bin2c\
    -D LAMMPS_MACHINE=g++_openmpi\
    -D PKG_GPU=on\
    -D GPU_API=cuda\
    -D GPU_ARCH=$gpu_arch

cmake --build build

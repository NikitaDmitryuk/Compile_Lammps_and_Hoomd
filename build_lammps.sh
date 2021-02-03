#! /bin/sh

NAME_CONTAINER='lammps_lj12-4'
ARCH_GPU="sm_61"

systemctl start docker

docker pull nvidia/cuda:10.2-devel-ubuntu18.04

docker run --runtime=nvidia --rm nvidia/cuda:10.2-devel-ubuntu18.04 nvidia-smi
docker run --rm --runtime=nvidia nvidia/cuda:10.2-devel-ubuntu18.04 nvcc --version

docker build -t $(NAME_CONTAINER) . --build-arg ARCH=$(ARCH_GPU)

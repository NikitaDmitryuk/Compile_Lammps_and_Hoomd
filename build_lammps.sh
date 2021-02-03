#! /bin/sh

systemctl start docker

docker pull nvidia/cuda:10.2-devel-ubuntu18.04

docker run --runtime=nvidia --rm nvidia/cuda:10.2-devel-ubuntu18.04 nvidia-smi
docker run --rm --runtime=nvidia nvidia/cuda:10.2-devel-ubuntu18.04 nvcc --version

docker build -t 'lammps_gpu_test_omp' .

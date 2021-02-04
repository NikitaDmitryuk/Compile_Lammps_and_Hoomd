#! /bin/sh

NAME_CONTAINER='lammps_mpi_test'
ARCH_GPU="sm_61"

systemctl start docker

docker build -t $NAME_CONTAINER . --build-arg ARCH=$ARCH_GPU

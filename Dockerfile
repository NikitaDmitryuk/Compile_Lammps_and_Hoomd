FROM nvidia/cuda:10.2-devel-ubuntu18.04

ARG ARCH

RUN apt-get -y update &&\
    apt-get -y install wget git sudo cmake build-essential openmpi-bin openmpi-common openssh-client openssh-server libopenmpi2 libopenmpi-dev libpng-dev zlib1g-dev gfortran ffmpeg pkg-config cmake-data fftw3 libzstd-dev
    
RUN mkdir -p /lammps &&\
    mkdir -p /srv/input

WORKDIR /lammps/

COPY /lammps /lammps/

RUN mkdir build && cd build 

WORKDIR /lammps/build/

RUN cmake -D CMAKE_INSTALL_PREFIX=/usr/local\
    -D CMAKE_LIBRARY_PATH=/usr/local/cuda/lib64/stubs\
    -D BIN2C=/usr/local/cuda/bin/bin2c\
    -D LAMMPS_MACHINE=g++_openmpi\
    -D PKG_GPU=on\
    -D GPU_API=cuda\
    -D GPU_ARCH=${ARCH}\
    ../cmake

RUN make -j$(nproc)
    
RUN make install

ENV PATH /usr/lib64/mpich/bin:${PATH}

WORKDIR /srv/input

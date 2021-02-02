FROM nvidia/cuda:10.2-devel-ubuntu18.04

LABEL maintainer="ssmns ssmns@outlook.com"
LABEL version="1.0-beta"
LABEL description="This is custom Docker Image for lammps-gpu package."

RUN apt-get -y update &&\
    apt-get -y install wget git cmake build-essential openmpi-bin openmpi-common openssh-client openssh-server libopenmpi2 libopenmpi-dev libpng-dev zlib1g-dev gfortran ffmpeg pkg-config cmake-data

# download and extract
RUN git clone https://github.com/lammps/lammps.git lammps &&\
    cd lammps &&\
    git checkout stable


RUN cd lammps &&\
    mkdir build &&\
    cd build &&\
    cmake -D CMAKE_INSTALL_PREFIX=/usr/local\
    -D CMAKE_LIBRARY_PATH=/usr/local/cuda/lib64/stubs\
    -D BIN2C=/usr/local/cuda/bin/bin2c\
    -D LAMMPS_MACHINE=gpu\
    -D PKG_MOLECULE=on\
    -D PKG_ASPHERE=on\
    -D PKG_BODY=on\
    -D PKG_CLASS2=on\
    -D PKG_COLLOID=on\
    -D PKG_COMPRESS=on\
    -D PKG_CORESHELL=on\
    -D PKG_DIPOLE=on\
    -D PKG_GRANULAR=on\
    -D PKG_KSPACE=on\
    -D PKG_MANYBODY=on\
    -D PKG_MC=on\
    -D PKG_MISC=on\
    -D PKG_PERI=on\ 
    -D PKG_QEQ=on\
    -D PKG_RIGID=on\
    -D PKG_SHOCK=on\
    -D PKG_SNAP=on\
    -D PKG_SRD=on\
    -D PKG_USER-REAXC=on\
    -D PKG_USER-TALLY=on\
    -D PKG_GPU=on\
    -D GPU_API=cuda\
    -D GPU_ARCH=sm_61\
    ../cmake

RUN cd /lammps/build &&\
    make -j6
    
RUN cd /lammps/build &&\
    make install

ENV PATH /usr/lib64/mpich/bin:${PATH}

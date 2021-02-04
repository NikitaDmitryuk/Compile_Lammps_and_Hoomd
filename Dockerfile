FROM nvidia/cuda:10.2-devel-ubuntu18.04

ARG ARCH

ARG USER_NAME=user_lammps

RUN apt-get -y update &&\
    apt-get -y install wget git sudo cmake build-essential openmpi-bin openmpi-common openssh-client openssh-server libopenmpi2 libopenmpi-dev libpng-dev zlib1g-dev gfortran ffmpeg pkg-config cmake-data fftw3 libzstd-dev
    

RUN groupadd --gid 2000 ${USER_NAME} &&\
    useradd --uid 2000 --gid ${USER_NAME} --shell /bin/bash --create-home ${USER_NAME}


RUN mkdir -p /home/${USER_NAME}/lammps &&\
    mkdir -p /home/${USER_NAME}/input

WORKDIR /home/${USER_NAME}/lammps/

COPY /lammps /home/${USER_NAME}/lammps/

RUN mkdir build && cd build 

WORKDIR /home/${USER_NAME}/lammps/build/

RUN cmake -D CMAKE_INSTALL_PREFIX=/usr/local\
    -D CMAKE_LIBRARY_PATH=/usr/local/cuda/lib64/stubs\
    -D BIN2C=/usr/local/cuda/bin/bin2c\
    -D LAMMPS_MACHINE=g++_openmpi\
    -D PKG_GPU=on\
    -D GPU_API=cuda\
    -D GPU_ARCH=${ARCH}\
    ../cmake
    
#     -D BUILD_MPI=yes\
#     -D BUILD_OMP=yes\
#     -D PKG_MOLECULE=on\
#     -D PKG_ASPHERE=on\
#     -D PKG_BODY=on\
#     -D PKG_CLASS2=on\
#     -D PKG_COLLOID=on\
#     -D PKG_COMPRESS=on\
#     -D PKG_CORESHELL=on\
#     -D PKG_DIPOLE=on\
#     -D PKG_GRANULAR=on\
#     -D PKG_KSPACE=on\
#     -D PKG_MANYBODY=on\
#     -D PKG_MC=on\
#     -D PKG_MISC=on\
#     -D PKG_PERI=on\ 
#     -D PKG_QEQ=on\
#     -D PKG_RIGID=on\
#     -D PKG_SHOCK=on\
#     -D PKG_SNAP=on\
#     -D PKG_SRD=on\
#     -D PKG_USER-REAXC=on\
#     -D PKG_USER-TALLY=on\

RUN make -j$(nproc)
    
RUN make install

ENV PATH /usr/lib64/mpich/bin:${PATH}

WORKDIR /home/${USER_NAME}/input

USER ${USER_NAME}

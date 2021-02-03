# lammps_docker
the molecular dynamics packages compiled with GPU supports . 


for compiling the Lammps packages need a base image ,because of own purpose ( use cuda for GPU processing )  install `nvidia/cuda` docker image. 
``` 
docker pull nvidia/cuda:10.2-devel-ubuntu18.04
```

two bellow commands must run perfectly without any error:

```
docker run --runtime=nvidia --rm nvidia/cuda:10.2-devel-ubuntu18.04 nvidia-smi
sudo docker run --rm --runtime=nvidia nvidia/cuda:10.2-devel-ubuntu18.04 nvcc --version
```

### build image

```shell
docker build -t 'lammps_gpu:2020' .
```

### use image

```shell
nvidia-docker run -ti -v $(pwd):/srv/input -v $HOME/scratch:/srv/scratch lammps_gpu:2020

lmp_gpu -in /srv/lammps/bench/in.lj

mpirun -np 4 lmp_gpu -in /srv/lammps/bench/in.lj

mpirun -np 4 lmp_gpu -in /srv/lammps/bench/in.lj -sf gpu
```

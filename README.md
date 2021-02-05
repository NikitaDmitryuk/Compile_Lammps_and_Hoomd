# Lammps nvidia-docker

Автор: [Никита Дмитрюк](https://github.com/NikitaDmitryuk)

Github repository: [Lammps_compile_gpu_env](https://github.com/NikitaDmitryuk/Lammps_compile_gpu_env)


***Docker*** позволяет создавать и запускать контейнеры со своей операционной системой и программами обособленно от компьютера, на котором запускается контейнер, соблюдая все зависимости и переменные среды. Это ускоряет развертывание программ на других компьютерах, так как не требуется устанавливать нужные зависимости, драйвера и тп.


### Первоначальная настройка

Для работы контейнера необходим ***docker*** и ***[nvidia-docker](https://github.com/NVIDIA/nvidia-docker)*** версии 2.5 или выше.

Перед использованием *docker* может понадобиться запустить службу:


```shell
sudo systemctl start docker
```

Необходимо загрузить следующий контейнер:

```shell
sudo docker pull nvidia/cuda:10.2-devel-ubuntu18.04
```

Следующие команды должны выполняться без ошибок:

```shell
docker run --runtime=nvidia --rm nvidia/cuda:10.2-devel-ubuntu18.04 nvidia-smi
sudo docker run --rm --runtime=nvidia nvidia/cuda:10.2-devel-ubuntu18.04 nvcc --version
```

### Сборка образа

В файле ***build_lammps.sh*** необходимо указать имя контейнера (*NAME_CONTAINER*), а также версию [архитектуры видеокарты](https://ru.wikipedia.org/wiki/CUDA) (*ARCH_GPU*).
Дополнительные параметры компиляции можно изменить в ***Dockerfile***.

Папка с исходным кодом с названием **lammps** или **жесткая ссылка** на нее должны находиться в одной папке со скриптом и Dockerfile (*lammps* можно скачать командой: `git clone --depth=1 --branch=stable https://github.com/lammps/lammps.git`).

Запустить скрипт:

```shell
sudo ./build_lammps.sh
```

Данная команда создаст контейнер и скомпилирует в нем lammps, который находится в папке ***/lammps в текущей директории***.

Собранный контейнер с названием *NAME_CONTAINER* хранится на компьютере, и не требует повторной сборки, его можно использовать из любой директории.

Список всех образов можно получить командой `sudo docker images`.

### Использование образа

Для запуска контейнера с установленным *lammps*:

```shell
nvidia-docker run -ti -v $(pwd):/home/user_lammps/input NAME_CONTAINER
```

Данная команда запускает контейнер с названием **NAME_CONTAINER**. Ключ *-v $(pwd):/home/user_lammps/input* задает папку на компьютере, доступную контейнеру (путь до двоеточия), а в контейнере это будет путь, указанный после двоеточия.

В данном случае контейнеру будет доступна папка, из которой запускается контейнер, а в контейнере все файлы будут лежать в */home/user_lammps/input*.

После запуска контейнера в нем можно выполнять команды и запускать lammps.

Пример:

```shell
lmp_g++_openmpi -sf gpu -pk gpu 1 -in in.file
```

# Lammps nvidia-docker

Autor: [Dmitryuk Nikita](https://github.com/NikitaDmitryuk)

Laboratory: [Soft Matter Group, Bauman MSTU](http://teratech.ru/en)

Github repository: [Lammps_compile_gpu_env](https://github.com/NikitaDmitryuk/Lammps_compile_gpu_env)

---

***Docker*** позволяет создавать и запускать контейнеры со своей операционной системой и программами обособленно от компьютера, на котором запускается контейнер, соблюдая все зависимости и переменные среды. Это ускоряет развертывание программ на других компьютерах, так как не требуется устанавливать нужные зависимости и программы.


## Первоначальная настройка

Для работы контейнера необходиы ***драйвера nvidia***, ***docker*** и ***[nvidia-docker](https://github.com/NVIDIA/nvidia-docker)*** версии 2.5 или выше.

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

## Сборка образа

В файле ***build_lammps.sh*** необходимо указать имя контейнера (*NAME_CONTAINER*), а также версию [архитектуры видеокарты](https://ru.wikipedia.org/wiki/CUDA) (*ARCH_GPU*).
Дополнительные параметры компиляции можно изменить в ***Dockerfile***.

Папка с исходным кодом с названием **lammps** или **жесткая ссылка** на нее должны находиться в одной папке со скриптом и Dockerfile (*lammps* можно скачать командой: `git clone --depth=1 --branch=stable https://github.com/lammps/lammps.git`).

Запустить скрипт:

```shell
sudo ./build_lammps.sh
```

Это создаст контейнер и скомпилирует в нем lammps, который находится в папке ***/lammps в текущей директории***.

Собранный контейнер с названием *NAME_CONTAINER* хранится на компьютере, и не требует повторной сборки, его можно использовать из любой директории.

Список всех образов можно получить командой `sudo docker images`.

## Использование образа

Для запуска контейнера с установленным *lammps*:

```shell
nvidia-docker run --rm -ti -v $(pwd):/home/user_lammps/input NAME_CONTAINER
```

Команда запускает контейнер с названием **NAME_CONTAINER**. Ключ *-v $(pwd):/home/user_lammps/input* задает папку на компьютере, доступную контейнеру (путь до двоеточия), а в контейнере это будет путь, указанный после двоеточия.

В данном случае контейнеру будет доступна папка, из которой запускается контейнер, а в контейнере все файлы будут лежать в */home/user_lammps/input*.

После запуска контейнера в нем можно выполнять команды и запускать lammps.

Пример:

```shell
lmp_g++_openmpi -sf gpu -pk gpu 1 -in in.file
```

Для выхода из контейнера можно использовать комбинацию клавиш `ctrl + d`.

## Изменение потенциала взаимодействия

При расчете на видеокарте используется потенциал, находящийся в файле исходников *lammps* по адресу */lib/gpu/lal_lj.cu*.

Для его замены необходимо поменять строку в которой рассчитывается сила взаимодействия между частицами (желательно в обеих функциях (*void k_lj, void k_lj_fast*)):


```c++
...
numtyp force = r2inv*r6inv*(lj1[mtype].x*r6inv-lj1[mtype].y);
...
```

Сила взаимодействия рассчитывается как *force = - u' / r*, где *u* - функция потенциала взаимодействия.

После чего необходимо заново скомпилировать *lammps* (пункт [сборки образа](https://github.com/NikitaDmitryuk/Lammps_compile_gpu_env/blob/main/README.md#%D1%81%D0%B1%D0%BE%D1%80%D0%BA%D0%B0-%D0%BE%D0%B1%D1%80%D0%B0%D0%B7%D0%B0)).

Новому образу можно дать название, соответствующее потенциалу взаимодействия (*NAME_CONTAINER*).

***

Для использования этого потенциала в моделировании *in.file* должен содержать следующие строки:

    ...
    package gpu 1
    ...
    pair_style lj/cut ${Rc}
    ...

*Lammps* необходимо запускать с ключами `-sf gpu -pk gpu 1`.

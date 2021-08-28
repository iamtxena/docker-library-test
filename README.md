# Docker tests

Testing how to properly set up a Dockerfile to use python libraries installed from source.

## Docker Cheat Sheet

### Build image

Build an image from a Dockerfile.

You need to specify the path `.` and you can also set the image name with `-t`

```bash
docker build . -t test
```

### Run image

Run an image, setting the container name, running a bash interactively and removing the container after the execution.

You can set the option `-d` (detach) to run it on the background.

```bash
docker run --name test --rm -it test bash
```

### Start a container

Starts a generated container and run it interactively.

```bash
docker start -i test
```

### Stop a container

Stops a running container.

```bash
docker stop test
```

## Dockerfile setup

### Base setup using `qibo` from the official `Pypi` repository

- Qibo library requires `scipy`, `numpy` and `matplotlib`. Those libraries are not possible to be installed using `pip` on an ARM Apple chip, and requires to be installed using `conda` from `miniconda`.

- There are a few pre-built docker images containing `miniconda`, the best one seems to be [continuumio/miniconda3](https://hub.docker.com/r/continuumio/miniconda3). Although on their github exists the alpine version of it, the one you pull from it, it is a debian-based image. The thing with this one is that you cannot install any other system library (but you can install any python library indeed), as the user is non-root. In my case, I need to install some other system packages, so it is not a suitable option for me.

- Another option is bulding the same image on your own. I tried to do that with the alpine version, but did not succeed. Conda uses glibc, and you need then to either install it on your own, or use a pre-built image with glibc installed. My code requires python 3.9 because I am using typings, so I need to take this into account when installing my own conda version to properly download one compatible with python 3.9.

- So, when following the `continuumio` docker steps to build the glibc, it raises an error because it cannot find the generated libraries. I tried a few times but I did not find the proper solution. Then, I decided to use another prebuilt image with glibc installed from [frolvlad/alpine-glibc](https://hub.docker.com/r/frolvlad/alpine-glibc), and using the `continuumio` instructions to install `conda` in it, using the `CONDA_VERSION=py_39_4.10.3` and its `sha256sum`.

- Just make sure to set the `PATH` variable with `conda` and `bin` directories, and initializing `conda`:

```docker
ENV PATH /bin:/sbin:/usr/bin:$PATH
ENV PATH /opt/conda/bin:$PATH
RUN conda init
```

- You can then install the required packages: `scipy`, `numpy`, and `matplotlib` using `conda`.

```docker
RUN conda install scipy numpy matplotlib
```

- And finally you can install `qibo`

```docker
RUN pip install qibo
```

### Using `qibo` from a local source code installation


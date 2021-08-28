# Docker tests

Testing how to properly set up a Dockerfile to use python libraries installed from source.

## Build image

Build an image from a Dockerfile.

You need to specify the path `.` and you can also set the image name with `-t`

```bash
docker build . -t test
```

## Run image

Run an image, setting the container name, running a bash interactively and removing the container after the execution.

You can set the option `-d` (detach) to run it on the background.

```bash
docker run --name test --rm -it test bash
```

## Start a container

Starts a generated container and run it interactively.

```bash
docker start -i test
```

## Stop a container

Stops a running container.

```bash
docker stop test
```

# docker_coreboot
A simple Docker container, prepared for developing and building apps, using crosscompiling for COREBOOT, based on coreboot/coreboot-sdk


## Clone

Make sure git is installed.
```sh
git clone https://github.com/risapav/docker_coreboot && cd docker_coreboot
```

## Build Docker container

Docker has to work reliably before we try to do anything. Instructions on how to do this can be found, for example, at the following links:

https://linuxhint.com/arch-linux-docker-tutorial/

The assembly of the container itself is very simple:

```sh
docker build -t coreboot-sdk .
```

or:

```sh
docker build https://github.com/risapav/docker_coreboot.git -t coreboot-sdk
```

## Run coreboot-sdk environment

Run Docker inside project directory. 

```sh
docker run --rm --privileged -it\
	--user "$(id -u):$(id -g)" \
	-v $PWD:/home/sdk \
	-w /home/sdk \
	coreboot-sdk
```
## Check if environment works properly

# todo

Inside container try run this:

```sh
[root@599a1acb72f3 project]# arm-none-eabi-cpp --version
[root@599a1acb72f3 project]# st-flash --version
[root@599a1acb72f3 project]# make -version
[root@599a1acb72f3 project]# cmake -version
[root@599a1acb72f3 project]# make && make flash
```

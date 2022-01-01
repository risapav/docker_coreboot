# FROM gcc:bullseye
FROM debian:stable-slim

MAINTAINER Pavol Risa "risapav at gmail"

# Prepare directory for tools
ARG DOCKER_ROOT="/home/sdk"
ARG ROOT_DIR=${DOCKER_ROOT}
ARG SCRIPT_DIR=${ROOT_DIR}/scripts

RUN apt-get update && apt-get -y --no-install-recommends install \
		apt-transport-https \
		ca-certificates \
		autoconf \
		automake \
		autopoint \
		gettext \
		gnulib \
		libtool \
		bison \
		build-essential \
		curl \
		flex \
		git \
		gnat \
		libncurses5-dev \
		m4 \
		zlib1g-dev \
		python3 \
		python-is-python3 \
		screen \
		mc \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& mkdir -p ${ROOT_DIR}

ENV LANG en_US.UTF-8 	

# prepare coreboot framework
WORKDIR ${ROOT_DIR}

VOLUME [${ROOT_DIR}]

CMD ["/bin/bash"]


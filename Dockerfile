# FROM gcc:bullseye
FROM debian:stable-slim

MAINTAINER Pavol Risa "risapav at gmail"

# Prepare toolchain
ARG TOOLCHAIN_SRC="~/coreboot"
# Prepare directory for tools
ARG DOCKER_ROOT="/home/sdk"
ARG ROOT_DIR=${DOCKER_ROOT}
ARG SCRIPT_DIR=${ROOT_DIR}/scripts

ENV LANG en_US.UTF-8 

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
		libopts25-dev \
		libncurses5-dev \
		libfreetype6-dev \
		pkg-config \
		m4 \
		zlib1g-dev \
		python3 \
		python-is-python3 \
		unifont \
		uuid-dev \
		mc \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& mkdir -p ${ROOT_DIR}} \
	&& mkdir -p /opt/xgcc \
	&& echo "export PATH=$PATH:/opt/xgcc/bin" >> ${DOCKER_ROOT}/.bashrc 
	

COPY ${TOOLCHAIN_SRC}/ /opt/xgcc

# prepare coreboot framework
WORKDIR ${ROOT_DIR}

VOLUME ${ROOT_DIR}

CMD ["/bin/bash"]


# FROM gcc:bullseye
FROM debian:stable-slim

MAINTAINER Pavol Risa "risapav at gmail"

# Prepare toolchain
ARG XGCC_DIR="/opt/xgcc"

ARG COREBOOT_SDK_TAG="4.12"
ENV COREBOOT_SDK_TAG=${COREBOOT_SDK_TAG}

ARG ARCH="i386"
ENV ARCH=${ARCH}

ARG COREBOOT_DIR="/tmp/coreboot"
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
	&& mkdir -p ${ROOT_DIR} 
	
RUN echo "cloning Coreboot framework from github" \
	&& echo "${DOCKER_ROOT} ${ROOT_DIR} ${XGCC_DIR} ${COREBOOT_DIR} ${COREBOOT_SDK_TAG} ${ARCH}" \
	&& git clone --branch $COREBOOT_SDK_TAG https://github.com/coreboot/coreboot ${COREBOOT_DIR} \
	&& mkdir -p ${XGCC_DIR} \
	&& echo "export PATH=$PATH:${XGCC_DIR}/bin" >> ${ROOT_DIR}/.bashrc \
	&& cd ${COREBOOT_DIR} \
	&& make crossgcc-${ARCH} CPUS=$(nproc) && rm -R /tmp/*
	
# prepare coreboot framework
WORKDIR ${ROOT_DIR}

VOLUME ${ROOT_DIR}

CMD ["/bin/bash"]


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
ARG BUILD_DIR=${ROOT_DIR}/build

ENV LANG en_US.UTF-8 

RUN apt-get update && apt-get -y --no-install-recommends install \
		apt-transport-https ca-certificates \
		autoconf automake autopoint \
		bison build-essential \
		curl \
		flex \
		git gettext gnat gnulib \
		libopts25-dev libncurses5-dev libfreetype6-dev libtool \
		m4 mc \
		pkg-config python3 python-is-python3 \
		unifont uuid-dev \
		zlib1g-dev \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& mkdir -p ${ROOT_DIR} ${BUILD_DIR} ${COREBOOT_DIR} ${XGCC_DIR} \
	&& echo "export PATH=$PATH:${XGCC_DIR}/bin" >> ${ROOT_DIR}/.bashrc \
	&& echo "${BUILD_DIR} ${COREBOOT_DIR}/"

ADD ${BUILD_DIR} ${COREBOOT_DIR}/

#	&& cd ${COREBOOT_DIR} 
RUN ls -la ${COREBOOT_DIR} && .${COREBOOT_DIR}/util/xcompile ${XGCC_DIR} 

# make crossgcc-${ARCH} CPUS=$(nproc) 

RUN rm -R /tmp/*
	
# prepare coreboot framework
WORKDIR ${ROOT_DIR}

VOLUME ${ROOT_DIR}

CMD ["/bin/bash"]


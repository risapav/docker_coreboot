# FROM gcc:bullseye
FROM debian:stable-slim

MAINTAINER Pavol Risa "risapav at gmail"

# Prepare directory for tools
ARG DOCKER_ROOT="/home/sdk"
ARG ROOT_DIR=${DOCKER_ROOT}
ARG SCRIPT_DIR=${ROOT_DIR}/scripts

# set locale attrib
RUN mkdir -p ${ROOT_DIR} && \
	apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install locales && \
	sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
	dpkg-reconfigure --frontend=noninteractive locales && \
	update-locale LANG=en_US.UTF-8 && \
	apt-transport-https ca-certificates \
	bison \
	flex \	
	git \
        iproute2 \
        jq \
        python3 \
        python-is-python3 \
        qemu-system-x86 \
        udhcpd \
        mc \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

ENV LANG en_US.UTF-8 

# prepare coreboot framework
WORKDIR ${ROOT_DIR}

VOLUME [${ROOT_DIR}]

CMD ["/bin/bash"]


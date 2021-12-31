# FROM gcc:bullseye
FROM debian:stable-slim

MAINTAINER Pavol Risa "risapav at gmail"

# Prepare directory for tools
ARG DOCKER_ROOT="/home/sdk"
ARG ROOT_DIR=${DOCKER_ROOT}
ARG SCRIPT_DIR=${ROOT_DIR}/scripts

# set locale attrib
# RUN apt-get update \
#	&& DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install locales \
#	&& sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
#	&& dpkg-reconfigure --frontend=noninteractive locales \
#	&& update-locale LANG=en_US.UTF-8 \
#	&& apt-transport-https ca-certificates 
	
# ENV LANG en_US.UTF-8 	
	
RUN apr-get update \
	&& apt-get -y --no-install-recommends install \
		bison \
		build-essential \
		curl \
		flex \
		git \
		gnat \
		libncurses5-dev \
		m4 \
		zlib1g-dev \
		mc \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& mkdir -p ${ROOT_DIR}


# prepare coreboot framework
WORKDIR ${ROOT_DIR}

VOLUME [${ROOT_DIR}]

CMD ["/bin/bash"]


FROM gcc:bullseye

MAINTAINER Pavol Risa "risapav at gmail"

# Prepare directory for tools
ARG COREBOOT_PATH=/home/sdk
ARG PROJECT_PATH=${COREBOOT_PATH}/prj
ARG UTIL_PATH=${COREBOOT_PATH}/coreboot/util
RUN mkdir -p ${PROJECT_PATH}

# set locale attrib
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install locales && \
	sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
	dpkg-reconfigure --frontend=noninteractive locales && \
	update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8 

# toolchain install
RUN apt-get update && apt-get -y --no-install-recommends install \
	apt-transport-https ca-certificates \
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

# prepare coreboot framework
WORKDIR ${COREBOOT_PATH}

VOLUME [${COREBOOT_PATH}]

CMD ["/bin/bash"]
	

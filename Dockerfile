FROM debian:bookworm-slim

MAINTAINER Pavol Risa "risapav at gmail"

# Prepare directory for tools
ARG COREBOOT_PATH=/home/coreboot
ARG PROJECT_PATH=${COREBOOT_PATH}/prj
ARG BUILD_PATH=${PROJECT_PATH}/build
ARG SCRIPTS_PATH=${PROJECT_PATH}/scripts
RUN mkdir -p ${BUILD_PATH} ${SCRIPTS_PATH} ${COREBOOT_PATH}
WORKDIR ${COREBOOT_PATH}

# set locale attrib
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install locales && \
	sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
	dpkg-reconfigure --frontend=noninteractive locales && \
	update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8 

# toolchain install
RUN apt-get update && apt-get -y upgrade && \
	apt-get -y --no-install-recommends install apt-transport-https ca-certificates \
		bison \
		build-essential \
		curl \
		flex \
		git \
		gnat \
		libncurses5-dev \
		m4 \
		zlib1g-dev \
        iproute2 \
        jq \
        python3 \
        python-is-python3 \
        qemu-system-x86 \
        udhcpd && \
	apt-get clean

#RUN update-ca-certificates
#RUN useradd -p locked -m coreboot && \
#	mkdir /root/.ssh && \
#	chmod 700 /root/.ssh
#COPY id_rsa id_rsa.pub /root/.ssh/ 
#COPY sudoers /etc/ 
#RUN chown root.root /etc/sudoers && chmod 440 /etc/sudoers
	
WORKDIR ${COREBOOT_PATH}
	
RUN  git clone https://github.com/coreboot/coreboot && \
	cd coreboot && \
	git submodule update --init --recursive && \
	git clone https://github.com/coreboot/blobs.git 3rdparty/blobs/ && \
	git clone https://github.com/coreboot/intel-microcode.git 3rdparty/intel-microcode/ && \
	make crossgcc-i386 CPUS=$(nproc)
	
# QEMU install
#sudo apt-get install qemu binfmt-support qemu-user-static # Install the qemu packages
#docker run --rm --privileged multiarch/qemu-user-static --reset -p yes # This step will execute the registering scripts

#docker run --rm -t arm64v8/ubuntu uname -m # Testing the emulation environment
#aarch64

# Change workdir
WORKDIR ${COREBOOT_PATH}
#ENTRYPOINT [${COREBOOT_PATH}]

#CMD ["/bin/bash"]

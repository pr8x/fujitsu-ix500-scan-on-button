# Use Ubuntu 22.04 (jammy) to match the SANE PPA
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
        gnupg \
        ca-certificates \
        software-properties-common \
        wget \
        sudo \
        git \
        sane-utils \
        scanbd \
        imagemagick \
        netpbm \
        ghostscript \
        poppler-utils \
        util-linux \
        parallel \
        units \
        bc \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1C4CBDCDCD2EFD2A \
    && add-apt-repository "deb http://ppa.launchpad.net/sane-project/sane-release/ubuntu jammy main" \
    && apt-get update && apt-get install -y sane-utils

WORKDIR /app

RUN git clone https://github.com/rocketraman/sane-scan-pdf.git

RUN mkdir /scans

RUN echo "usb 0x04c5 0x132b" >> /etc/sane.d/fujitsu.conf
RUN echo "usb 0x04c5 0x132b" >> /etc/scanbd/fujitsu.conf

COPY scanbd.conf /etc/scanbd/scanbd.conf
COPY scan.sh /etc/scanbd/scripts/scan.sh

VOLUME /scans

CMD ["scanbd", "-d1", "-f"]

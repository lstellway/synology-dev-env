FROM ubuntu:22.04
 
WORKDIR /data

RUN apt -y update \
    && apt -y upgrade \
    && apt install -y \
        git \
        vim \
        cifs-utils \
        nodejs \
        python3 \
        python3-pip \
    && mkdir -p /data/toolkit/source

ENV ENV="/etc/profile"

COPY .dev/profile.d/* /etc/profile.d/

CMD [ "tail", "-f", "/dev/null" ]

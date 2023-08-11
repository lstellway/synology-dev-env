FROM ubuntu:22.04
 
RUN apt -y update \
    && apt -y upgrade \
    && apt install -y \
        git \
        vim \
        cifs-utils \
        nodejs \
        python3 \
        python3-pip

ENV ENV="/etc/profile"

COPY .dev/profile.d/* /etc/profile.d/

WORKDIR /data

CMD [ "tail", "-f", "/dev/null" ]

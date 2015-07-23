FROM debian:8.1

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y \
        php5-cli \
        curl \
        ca-certificates \
        git-core \
        ssh \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

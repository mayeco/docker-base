#!/bin/bash

export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive
export TERM dumb

echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache

## Temporarily disable dpkg fsync to make building faster.
if [[ ! -e /etc/dpkg/dpkg.cfg.d/docker-apt-speedup ]]; then
    echo force-unsafe-io > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup
fi

## Prevent initramfs updates from trying to run grub and lilo.
## https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
## http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=594189
export INITRD=no
mkdir -p /etc/container_environment
echo -n no > /etc/container_environment/INITRD

## Replace the 'ischroot' tool to make it always return true.
## Prevent initscripts updates from breaking /dev/shm.
## https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
## https://bugs.launchpad.net/launchpad/+bug/974584
dpkg-divert --local --rename --add /usr/bin/ischroot
ln -sf /bin/true /usr/bin/ischroot


apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        apt-transport-https \
        php5-cli \
        git-core \
        curl \
        ssh \

apt-get clean && rm -rf /prepare.sh rm -rf /var/lib/apt/lists/* && rm -rf /tmp/* /var/tmp/*

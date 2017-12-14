#!/bin/sh

# Install docker-engine
mkfs -t btrfs /dev/sdb
mkdir -p /var/lib/docker
echo "/dev/sdb     /var/lib/docker   btrfs   defaults 1 2" >> /etc/fstab
mount /var/lib/docker

# Openstack requires docker 1.12 and this would install docker-ce-17.03
#yum install -y docker-engine
#systemctl start docker
#systemctl enable docker

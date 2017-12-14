#!/bin/sh

cp /dev/null /etc/motd

sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

# Disable firewall
systemctl stop firewalld
systemctl disable firewalld

# Enable chronyd, which already is installed
systemctl start chronyd
systemctl enable chronyd

yum -y update --exlude=kernel-uek*
yum -y install yum-utils

# NOTE: chronyd is already installed
# yum -y install ntp

yum-config-manager --enable ol7_addons
yum-config-manager --enable ol7_openstack30 ol7_openstack_extras

# Setup BTRFS for docker-engine
mkfs -t btrfs /dev/sdb
mkdir -p /var/lib/docker
echo "/dev/sdb     /var/lib/docker   btrfs   defaults 1 2" >> /etc/fstab
mount /var/lib/docker

# Openstack requires docker 1.12 and this would install docker-ce-17.03
#yum install -y docker-engine
#systemctl start docker
#systemctl enable docker

# This will start and enable docker
yum install -y openstack-kolla-preinstall

usermod -aG docker vagrant

#!/bin/sh

cp /dev/null /etc/motd

sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

# Disable firewall
systemctl stop firewalld
systemctl disable firewalld

# Enable chronyd, which already is installed
systemctl start chronyd
systemctl enable chronyd

# This will start and enable docker
yum install -y openstack-kolla-preinstall

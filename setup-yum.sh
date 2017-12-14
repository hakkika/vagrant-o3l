#!/bin/sh

yum -y update
yum -y install yum-utils

# NOTE: chronyd is already installed
# yum -y install ntp

yum-config-manager --enable ol7_addons
yum-config-manager --enable ol7_openstack30 ol7_openstack_extras

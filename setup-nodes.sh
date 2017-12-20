#!/bin/sh

# This is script is run manually on the controller-1 node

if [ "$USER" != "kolla" ]; then
    echo "This script must be run as user kolla"
    exit 1
fi

kollacli host add controller-1
kollacli host add controller-2
kollacli host add network
kollacli host add comp-1
kollacli host add comp-2

kollacli host list

kollacli host setup --file /vagrant/node-passwords.yml

kollacli host check all

kollacli group addhost control controller-1
kollacli group addhost control controller-2
kollacli group addhost database controller-1
kollacli group addhost database controller-2
kollacli group addhost storage controller-1
kollacli group addhost storage controller-2

kollacli group addhost network network

kollacli group addhost compute comp-1
kollacli group addhost compute comp-2

kollacli group listhosts
kollacli host list

# This is the default value
# kollacli property set openstack_release 3.0.1

# Set virtual ip to 192.168.56.110 in the configuration file at /usr/share/kolla/ansible/group_vars/__GLOBAL__
# Virtual ip is also set as a kolla property
kollacli property set kolla_internal_address 192.168.56.110

kollacli property set network_interface eth1
kollacli property set tunnel_interface eth2
kollacli property set neutron_external_interface eth3

# This should be a VIP, an unused IP on your network that will float between
# the hosts running keepalived for high-availability. When running an All-In-One
# without haproxy and keepalived, this should be the first IP on your
# 'network_interface' as set in the Networking section below.
cp -a /usr/share/kolla/ansible/group_vars/__GLOBAL__ /usr/share/kolla/ansible/group_vars/__GLOBAL__.ORIG
sed -i '/^kolla_internal_vip_address: /s/10.10.10.254/192.168.56.110/' /usr/share/kolla/ansible/group_vars/__GLOBAL__

# Docker registry settings
kollacli set property docker_registry ""
kollacli set property docker_namespace oracle

# Setting the passwords
echo "**** Setting the passwords"
kollacli password set keystone_admin_password
kollacli password init

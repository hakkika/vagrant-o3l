#!/bin/sh

cp /dev/null /etc/motd

sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

# Disable firewall
systemctl stop firewalld
systemctl disable firewalld

# Configure chronyd
sed -i 's;#allow 192.168.0.0/16;allow 192.168.0.0/16;' /etc/chrony.conf

# Enable chronyd, which already is installed
systemctl start chronyd
systemctl enable chronyd

yum -y install kernel-uek-devel
# yum -y update --exclude=kernel-uek*
yum -y update
yum -y install yum-utils unzip bzip2

# NOTE: chronyd is already installed
# yum -y install ntp

yum-config-manager --enable ol7_addons
yum-config-manager --enable ol7_openstack30 ol7_openstack_extras
yum-config-manager --enable ol7_optional_latest
yum-config-manager --disable ol7_developer ol7_developer_EPEL ol7_preview

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

# Copy Bash rc files for the kolla user
cp /etc/skel/.bash* /usr/share/kolla
chown kolla:kolla /usr/share/kolla/.bash*

# Add vagrant user to the docker group
usermod -aG docker vagrant

# Set password for the root
echo "root:K0lla123" | chpasswd

# Enable SSH connections using password
sed -i '/^PasswordAuthentication/s/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd

cat /vagrant/ol-hosts.txt >> /etc/hosts

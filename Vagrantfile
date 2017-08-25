# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  config.vbguest.auto_update = false

  # Spin up two controllers
  (1..2).each do |i|
    config.vm.define "controller-#{i}" do |controller|
      controller.vm.box = "ol74_kh"
      controller.vm.hostname = "controller-#{i}"

      controller.vm.provider "virtualbox" do |vb|
           vb.name = "controller-#{i}"
           vb.memory = "8192"
           second_disk_file = "docker_disk-con#{i}.vdi"

           unless File.exist?(second_disk_file)
              vb.customize ['createhd', '--filename', second_disk_file, '--size', 20 * 1024]
           end
           vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', second_disk_file]

      end
      controller.vm.provision :shell, inline: <<-SHELL
           cp /dev/null /etc/motd

           # Install docker-ce
           mkfs -t btrfs /dev/sdb
           mkdir -p /var/lib/docker
           echo "/dev/sdb     /var/lib/docker   btrfs   defaults 1 2" >> /etc/fstab
           mount /var/lib/docker
           yum-config-manager --enable ol7_addons
           # Openstack requires docker 1.12 and this would install docker-ce-17.03
           #yum install -y docker-engine
           #systemctl start docker
           #systemctl enable docker

           sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

           # Enable chronyd, which already is installed
           systemctl start chronyd
           systemctl enable chronyd

           yum-config-manager --enable ol7_openstack30 ol7_openstack_extras

           # This will start and enable docker
           yum install -y openstack-kolla-preinstall

      SHELL

      if i == 1
         controller.vm.provision :shell, inline: <<-SHELL
            yum install -y openstack-kollacli openstack-kolla-utils
         SHELL
      end

    end
  end

  # Network node
  config.vm.define :network do |net|
    net.vm.box = "ol74_kh"
    net.vm.hostname = "net"

    net.vm.provider "virtualbox" do |vb|
      vb.name = "net"
      vb.memory = "2048"

      second_disk_file = "docker_disk-net.vdi"

      unless File.exist?(second_disk_file)
         vb.customize ['createhd', '--filename', second_disk_file, '--size', 20 * 1024]
      end
      vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', second_disk_file]
    end

    net.vm.provision :shell, inline: <<-SHELL
       cp /dev/null /etc/motd

       mkfs -t btrfs /dev/sdb
       mkdir -p /var/lib/docker
       echo "/dev/sdb     /var/lib/docker   btrfs   defaults 1 2" >> /etc/fstab
       mount /var/lib/docker
       yum-config-manager --enable ol7_addons

       sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

       # Enable chronyd, which already is installed
       systemctl start chronyd
       systemctl enable chronyd

       yum-config-manager --enable ol7_openstack30 ol7_openstack_extras

       # This will start and enable docker
       yum install -y openstack-kolla-preinstall

    SHELL

  end

end

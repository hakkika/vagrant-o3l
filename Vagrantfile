# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  # config.vbguest.auto_update = false

  # Spin up two controllers
  (1..2).each do |i|
    config.vm.define "controller-#{i}" do |controller|
      controller.vm.box = "ol74"
      controller.vm.hostname = "controller-#{i}"

      # Add host-only network interface
      controller.vm.network "private_network", ip: "192.168.56.2#{i}"

      # Add internal network interface
      controller.vm.network "private_network", ip: "10.10.10.1#{i}", virtualbox__intnet: "intnet"

      controller.vm.provider "virtualbox" do |vb|
           vb.name = "controller-#{i}"
           vb.memory = "8192"
      end

      controller.vm.provision :shell, :path => "provision.sh"

      if i == 1
         controller.vm.provision :shell, inline: <<-SHELL
            yum install -y openstack-kollacli openstack-kolla-utils
         SHELL
      end

      controller.vm.provision :reload
    end
  end

  # Network node
  config.vm.define :network do |net|
    net.vm.box = "ol74"
    net.vm.hostname = "net"

    # Add host-only network interface
    net.vm.network "private_network", ip: "192.168.56.30"

    net.vm.provider "virtualbox" do |vb|
      vb.name = "net"
      vb.memory = "2048"
    end

    net.vm.provision :shell, :path => "provision.sh"

    net.vm.provision :reload

  end

end

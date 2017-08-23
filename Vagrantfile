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
      end
      controller.vm.provision :shell, inline: <<-SHELL
           cp /dev/null /etc/motd
      SHELL
    end
  end

end

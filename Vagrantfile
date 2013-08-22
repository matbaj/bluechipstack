# -*- mode: ruby -*-
# vi: set ft=ruby :

def file_dir_or_symlink_exists?(path_to_file)
  File.exist?(path_to_file) || File.symlink?(path_to_file)
end

BOX_NAME = ENV['BOX_NAME'] || "ubuntu"
BOX_URI = ENV['BOX_URI'] || "http://files.vagrantup.com/precise64.box"
VF_BOX_URI = ENV['BOX_URI'] || "http://files.vagrantup.com/precise64_vmware_fusion.box"
FORWARD_PORTS = ENV['FORWARD_PORTS']

Vagrant::Config.run do |config|
  if !file_dir_or_symlink_exists?("setuprc")
    print "A setuprc file for the install is missing.  Run './bluechip_openstack_setup.sh' to generate one.\n\n"
    exit
  end
 
  # Setup virtual machine box in bridged mode. 
  config.vm.network :bridged , ENV['CHEF_IP'] 
  config.vm.box = BOX_NAME
  config.vm.host_name = "chef-server"
  config.vm.box_url = BOX_URI

  # Provision and install new kernel if deployment was not done
  if Dir.glob("#{File.dirname(__FILE__)}/.vagrant/machines/default/*/id").empty?
    config.vm.provision :shell, :path => "bluechip_openstack_provision.sh"
  end
end

# Providers were added on Vagrant >= 1.1.0
Vagrant::VERSION >= "1.1.0" and Vagrant.configure("2") do |config|
  config.vm.provider :rackspace do |rs|
    config.ssh.private_key_path = ENV["RS_PRIVATE_KEY"]
    rs.username = ENV["RS_USERNAME"]
    rs.api_key  = ENV["RS_API_KEY"]
    rs.public_key_path = ENV["RS_PUBLIC_KEY"]
    rs.flavor   = /512MB/
    rs.image    = /Ubuntu/
  end

  config.vm.provider :virtualbox do |vb|
    config.vm.box = BOX_NAME
    config.vm.box_url = BOX_URI
  end
end

if !FORWARD_PORTS.nil?
  Vagrant::VERSION < "1.1.0" and Vagrant::Config.run do |config|
    (49000..49900).each do |port|
      config.vm.forward_port port, port
    end
  end

  Vagrant::VERSION >= "1.1.0" and Vagrant.configure("2") do |config|
    (49000..49900).each do |port|
      config.vm.network :forwarded_port, :host => port, :guest => port
    end
  end
end


#!/bin/bash 
apt-get -y install git;
apt-get -y install curl;
ssh-keygen -N "" -f /root/.ssh/id_rsa
git clone https://github.com/bluechiptek/bluechipstack.git /root/bluechipstack/;
cp /vagrant/setuprc /root/bluechipstack/;
curl -s -L https://raw.github.com/rcbops/support-tools/master/chef-install/install-chef-server.sh | bash;
curl -s -L https://raw.github.com/rcbops/support-tools/master/chef-install/install-cookbooks.sh | bash;

echo "=========================================================="
echo "Vagrant Chef server provisioning is complete."
echo;
echo "Type the following to continue:"
echo "1. 'vagrant ssh' to connect to the Chef server."
echo "2. 'sudo su' to become root."
echo "3. 'cd /root/bluechipstack/' to change directory."
echo "4. './bluechip_openstack_install.sh' to resume install."
echo "=========================================================="
echo;

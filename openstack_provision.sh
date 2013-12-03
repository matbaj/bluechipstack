#!/bin/bash 

# disable that stupid locale error
sed '/SendEnv LANG LC_*/d' /etc/ssh/ssh_config > /tmp/ssh_config.tmp
cp /tmp/ssh_config.tmp /etc/ssh/ssh_config

# install git and curl
apt-get -y install git;
apt-get -y install curl;

# checkout scripts again to the chef server and copy config file over 
git clone https://github.com/matbaj/bluechipstack.git /root/bluechipstack/;
cp /vagrant/setuprc /root/bluechipstack/;

# install chef server and the rackspace cookbooks
cat /root/bluechipstack/openstack_chef_server.sh | bash;
curl -s -L https://raw.github.com/rcbops/support-tools/master/chef-install/install-cookbooks.sh | bash;

# generate a key for pushing to nodes
ssh-keygen -N "" -f /root/.ssh/id_rsa

# add path for knife
echo "export PATH=$PATH:/opt/chef-server/bin/" >> /root/.bashrc

# shout out to the user
echo "=========================================================="
echo "Vagrant Chef server provisioning is complete."
echo;
echo "Type the following to continue:"
echo "1. 'vagrant ssh' to connect to the Chef server."
echo "2. 'sudo su' to become root on the Chef server."
echo "3. 'cd /root/bluechipstack/' to change directories."
echo "4. './openstack_install.sh' to resume install."
echo "=========================================================="
echo;

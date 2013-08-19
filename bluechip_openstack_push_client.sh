#!/bin/bash

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "You need to be 'root' dude." 1>&2
   exit 1
fi

# just so we're all clear
clear 

# see if we have our setuprc file available and source it
if [ -f ./setuprc ]
then
  . ./setuprc
else
  echo "##########################################################################################################################"
  echo;
  echo "A setuprc config file wasn't found & the install must halt.  Report this at https://github.com/bluechiptek/bluechipstack."
  echo;
  echo "##########################################################################################################################"
  exit;
fi

num_nodes=$NUMBER_NODES

echo "##########################################################################################################################"
echo;

# generate a keyfile
mkdir /root/.ssh/
ssh-keygen -N "" -f /root/.ssh/id_rsa

echo;
echo "A ssh key has been generated to copy to the nodes.  Use '"$ROOT_PASSWD"' for each copy prompt below."
echo;

# loop through config's machines and add to /etc/hosts
for (( x=1; x<=$num_nodes; x++ ))
  do
    host="NODE_"$x"_HOSTNAME"
    ip="NODE_"$x"_IP"
    echo "${!ip}	${!host}" >> /etc/hosts
  done

# loop through config's nodes and push out keyfile
for (( x=1; x<=$num_nodes; x++ ))
  do
    host="NODE_"$x"_HOSTNAME"
    ssh-copy-id root@${!host}
  done

# loop through the nodes and install chef_client

echo;
echo "When you are done pushing keys to the nodes you may run './bluechip_openstack_push_keys.sh' to continue."
echo;
echo "##########################################################################################################################"

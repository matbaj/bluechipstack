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

# loop through config's machines and add to /etc/hosts
rm -f /tmp/.node_hosts
for (( x=1; x<=$num_nodes; x++ ))
  do
    host="NODE_"$x"_HOSTNAME"
    ip="NODE_"$x"_IP"
    echo "${!ip}	${!host}" >> /etc/hosts
    echo "${!ip}	${!host}" >> /tmp/.node_hosts
  done

echo "##########################################################################################################################"
echo; 
echo "The following steps must be done manually for each node in your cluster.  The commands are listed below for convenience."
echo; 
echo "1. Do a ssh to each of the "$num_nodes" nodes and set the root password to: '"$ROOT_PASSWD"':"
echo;
for (( x=1; x<=$num_nodes; x++ ))
  do
    host="NODE_"$x"_HOSTNAME"
    ip="NODE_"$x"_IP"
    echo "ssh ${!host}"
    echo "sudo passwd root"
    echo "exit"
    echo; 
  done
echo;
echo;
echo "2. Push the ssh key to each of the "$num_nodes" nodes:"
echo;
for (( x=1; x<=$num_nodes; x++ ))
  do
    host="NODE_"$x"_HOSTNAME"
    ip="NODE_"$x"_IP"
    echo "ssh-copy-id root@"${!host}
  done
echo;
echo;
echo "3. Copy the host entry file for the nodes and paste them at the bottom of each node's /etc/hosts file: "
echo;
for (( x=1; x<=$num_nodes; x++ ))
  do
    host="NODE_"$x"_HOSTNAME"
    ip="NODE_"$x"_IP"
    echo "scp /tmp/.node_hosts root@"${!host}":/root/.node_hosts" 
    echo "ssh root@"${!host}" cat /root/.node_hosts >> /etc/hosts"
    echo "ssh root@"${!host}" rm /root/.node_hosts"
    echo; 
  done
echo;
echo "##########################################################################################################################"

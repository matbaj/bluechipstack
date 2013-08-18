#!/bin/bash

# just so we're all clear
clear 

if [ -f ./setuprc ]
then
	echo "########################################################################################################################"
	echo;
	echo "Setup has already been run.  Edit or delete the ./setuprc file in this directory to reconfigure setup."
	echo;
	echo "########################################################################################################################"
	echo;
	exit
fi

# single or multi?
echo;
read -p "How many total nodes in this install? " -r
if [ $REPLY -eq $REPLY 2>/dev/null ]
then
  BCT_NUMBER_NODES=$REPLY
else
  echo;
  echo "You need to enter an integer value."
  exit;
fi

# prompt for a few things we'll need for setup
for (( x=1; x<=$BCT_NUMBER_NODES; x++ ))
  do
    read -p "Enter a short hostname for node #"$x": "
    echo "NODE_"$x"_HOSTNAME="$REPLY >> setuprc
    read -p "Enter the IP address for node #"$x" ($REPLY): "
    echo "NODE_"$x"_IP="$REPLY >> setuprc
  done
read -p "Enter the email address for service accounts (nova, glance, keystone, quantum, etc.): " email
echo;
read -p "Enter a short name to use for your default region: " region
echo;

# making a unique token for this install
token=`cat /dev/urandom | head -c2048 | md5sum | cut -d' ' -f1`

cat > setuprc <<EOF
export SG_INSTALL_SWIFT=$SG_INSTALL_SWIFT
export SG_MULTI_NODE=$SG_MULTI_NODE
export SG_SERVICE_EMAIL=$email
export SG_SERVICE_PASSWORD=$password
export SG_SERVICE_TOKEN=$token
export SG_SERVICE_REGION=$region
EOF

echo "Using the following for setup.  Edit 'setuprc' if you don't like what you see."
echo
cat setuprc
echo

echo "#############################################################################################################"
echo;
echo "Setup configuration complete.  Continue the setup by doing a './bluechip_openstack_install.sh'."
echo;
echo "#############################################################################################################"
echo;

## Installing OpenStack Grizzly in 15 Minutes
It's been over a year since I published the [Install OpenStack in 10 Minutes](http://www.stackgeek.com/guides/gettingstarted.html) guide.  A year and nearly 10K installs later, I'm pleased to announce an even easier way to install OpenStack Grizzly.

Before we drop in and begin our exciting journey down the virtualized rabbit hole, I'd like to thank [Blue Chip Tek](http://bluechiptek.com) for providing hardware setup assistance, [Dell Computers](http://dell.com/) for donating the test hardware, and the awesome folks at [Rackspace](http://rackspace.com/) for writing and supporting the Chef scripts which are used for the bulk of the setup process.

The new install scripts are [available for download](https://github.com/bluechiptek/bluechipstack) from Github.  It is recommended you familiarize yourself with the install process by watching the screencast below.

INSERT VIDEO HERE

### Prerequisites for Install
The new install process uses a Chef server running inside a Vagrant instance on a deskto/laptop to provision the nodes of an OpenStack cluster.  If you already have Vagrant installed, you can skip to the download script section below.

If you don't have Vagrant installed yet, you'll need to download both [Vagrant](http://downloads.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads). To save a bit of time, here are the links to Vagrant 1.2.7 for [Windows](http://files.vagrantup.com/packages/7ec0ee1d00a916f80b109a298bab08e391945243/Vagrant_1.2.7.msi)/[OSX](http://files.vagrantup.com/packages/7ec0ee1d00a916f80b109a298bab08e391945243/Vagrant-1.2.7.dmg) and  for VirtualBox 4.2.16 for [Windows](http://download.virtualbox.org/virtualbox/4.2.16/VirtualBox-4.2.16-86992-Win.exe)/[OSX](http://download.virtualbox.org/virtualbox/4.2.16/VirtualBox-4.2.16-86992-OSX.dmg).

Double click each package to run through the installation of both VirtualBox and on your local machine.

### Download the Install Scripts
Start a terminal on your machine and make sure you have *git* installed.  If you don't, you can [download it here](http://git-scm.com/downloads).  Make and move yourself into a directory of your choice:

    mkdir openstack; cd openstack
    
Next, clone the scripts from the repo:

    git clone https://github.com/bluechiptek/bluechipstack.git
    
Now move into the scripts directory:

    cd bluechipstack
    
### Create the Setup File
The setup script provided in the repository will prompt you for a few variables, including the number of nodes for the cluster, the node IPs and names, and the network you'll be using for instances.  Start the setup script by typing the following:

    ./openstack_setup.sh
    
Once the setup script finishes, you will have a *setuprc* file that will roughly look like:

    export NUMBER_NODES=3
    export NODE_1_HOSTNAME=nero
    export NODE_1_IP=10.0.10.102
    export NODE_2_HOSTNAME=spartacus
    export NODE_2_IP=10.0.10.103
    export NODE_3_HOSTNAME=invictus
    export NODE_3_IP=10.0.10.104
    export CHEF_IP=10.0.10.101
    export ROOT_PASSWD=d304cdf4f456a36afc8d5adace011029
    
*Note: If you are using a Windows box for hosting the Vagrant image, you won't be able to run the **openstack_setup.sh** script.  Instead, move the **setuprc.example** file provided to **setuprc** and edit as needed:*

    move C:\downloads\bluechipstack\setuprc.example C:\downloads\bluechipstack\setuprc
    edit C:\downloads\bluechipstack\setuprc
  
### Start the Chef Server
The Chef server is built and started by the Vagrant manager and should take 5-10 minutes to build on a fast box and connection.  Start the server by typing:

    vagrant up
    
Once the Chef server is provisioned, you can ssh into it by typing:

    vagrant ssh

Once logged into the server, become root and change into the *bluechipstack* directory:

    sudo su
    cd /root/bluechipstack
    
Now run the install script to print the node configuration commands:

    ./openstack_install.sh
    
### Configuring the Nodes
Each of the nodes you'll be installing to needs to be running [Ubuntu Server 12.04](http://www.ubuntu.com/download/server) on it, be connected to your local network, and have the IPs you specified earlier. The install script will dump out instructions and commands you can cut and paste to save time.  *Be sure to execute these commands from the Chef server!* 

**1. Begin by setting a root password on each node:**

    ssh user@hostname
    sudo passwd root
    exit
    
*Note: You'll need to replace the **user** and **hostname** and repeat these steps for each and every node you specified in the setup.  For each node, you will be prompted for your user password twice and the new root password twice.*

**2. Next, push the root key to each node:**

    ssh-copy-id root@hostname

*Note: Again, you will need to replace **hostname** and repeat this for each node.  You will be prompted by the nodes for the root password you set in step 1 above.*

**3. Finally, update the /etc/hosts file and clear the root password for each node:**

    scp /tmp/.node_hosts root@hostname:/root/.node_hosts
    ssh root@hostname cat /root/.node_hosts >> /etc/hosts
    ssh root@hostname rm /root/.node_hosts
    ssh root@hostname passwd -l root
    
*Note: And, once again, replace the **hostname** and repeat for each node.  No passwords required this time!*

### Provision the Nodes

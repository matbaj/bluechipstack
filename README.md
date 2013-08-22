## Installing OpenStack Grizzly in 15 Minutes
It's been over a year since I published Install OpenStack in 10 Minutes guide.  A year and nearly 10K installs later, I'm pleased to announce the next chapter in the OpenStack install saga.

Before we drop in and begin our exciting journey down the virtualized rabbit hole, I'd like to thank [Blue Chip Tek](http://bluechiptek.com) for providing hardware setup assistance, [Dell Computers](http://dell.com/) for donating the test hardware, and the awesome folks at [Rackspace](http://rackspace.com/) for writing and supporting the Chef scripts which are used for the bulk of the setup process.

The new install scripts are [available for download](https://github.com/bluechiptek/bluechipstack) from Blue Chip's Github account.  You can familiarize yourself with the install process by watching the screencast below.

INSERT VIDEO HERE

### Prerequisites for Install
The new install process uses a Chef server running inside Vagrant instance on your personal machine to provision the servers for your OpenStack cluster.  If you already have Vagrant installed, you can skip to the section below and begin downloading the scripts.

If you don't have Vagrant installed yet, you'll need to download both [Vagrant](http://downloads.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads). To save a bit of time, here are the links to Vagrant 1.2.7 for [Windows](http://files.vagrantup.com/packages/7ec0ee1d00a916f80b109a298bab08e391945243/Vagrant_1.2.7.msi)/[OSX](http://files.vagrantup.com/packages/7ec0ee1d00a916f80b109a298bab08e391945243/Vagrant-1.2.7.dmg) and  for VirtualBox 4.2.16 for [Windows](http://download.virtualbox.org/virtualbox/4.2.16/VirtualBox-4.2.16-86992-Win.exe)/[OSX](http://download.virtualbox.org/virtualbox/4.2.16/VirtualBox-4.2.16-86992-OSX.dmg).

Double click each package to run through the installation of both VirtualBox and on your local machine.

### Download the Install Scripts
Start a terminal on your machine and make sure you have *git* installed.  If you don't, you can [download it here](http://git-scm.com/downloads).  Make and move yourself into a directory of your choice:

    mkdir openstack; cd openstack
    
Next, clone the scripts from the Blue Chip repo:

    git clone https://github.com/bluechiptek/bluechipstack.git
    
Now move into the scripts directory:

    cd bluechipstack
    
*Note: If you are using a Windows box for hosting the Vagrant image, you'll need to install [Cygwin](http://www.cygwin.com/) so you can run the install scripts.  If you are using OSX, you don't have to do anything other than run the scripts.*
    
### Create the Setup File
The setup script provided in the repository will prompt you for a few variables, including the number of nodes for the cluster, the node IPs and names, and the network you'll be using for instances.  Start the setup script by typing the following:

    ./bluechip_openstack_setup.sh
    
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
  
### Start the Chef Server
The Chef server is built and started by the Vagrant manager.  The initial provisioning process should take 5-10 minutes on a fast connection.  Start the Chef server by doing the following:

    vagrant up
    
Once the Chef server is provisioned, you can connect to it by doing the following:

    vagrant ssh
    
### Configure the Node's Logins

    



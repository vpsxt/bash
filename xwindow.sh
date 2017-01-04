#!/bin/sh

# This script is FREE and written by www.vpsmm.com

# install yum-fastestmirror
yum -y install yum-fastestmirror  

# Create new soft download dir
mkdir -p /backup/www.vpsmm.com;
cd /backup/www.vpsmm.com;

# Install x window softwares
yum -y groupinstall "X Window System"
yum -y  groupinstall "GNOME Desktop Environment"
yum -y  install nc expect freenx
yum -y  groupinstall chinese-support


#install firefox
yum -y install firefox

# Copy client.id_dsa.key to /backup/www.vpsmm.com/
# Please use FTP or winscp to download it

cp /etc/nxserver/client.id_dsa.key /backup/www.vpsmm.com/
chmod 755 /backup/www.vpsmm.com/client.id_dsa.key 


# iptables 

iptables -A INPUT -i lo -s 127.0.0.1 -j ACCEPT 
iptables -A INPUT -p tcp --dport 22 -j ACCEPT 
iptables -A OUTPUT -p udp --sport 22 -j ACCEPT 
iptables -A INPUT -p tcp --dport 5000 -j ACCEPT 
iptables -A OUTPUT -p udp --sport 5000 -j ACCEPT
sed -i 's#SELINUX=enforcing#SELINUX=disabled'# /etc/selinux/config

echo "==========================="
	get_char()
	{
	SAVEDSTTY=`stty -g`
	stty -echo
	stty cbreak
	dd if=/dev/tty bs=1 count=1 2> /dev/null
	stty -raw
	stty echo
	stty $SAVEDSTTY
	}
	echo ""
	echo "======= Download FreeNX Windows software  : ======= "
        echo ""
        echo "http://down.vpsmm.com/shell/xwindows.sh"
        echo ""
        echo ""

        echo "======= How to use FreeNX connect to your Linux X Window System: ======= "
        echo "https://wiki.vpsmm.com/linux-vps-setup-a-desktop/"
        echo ""
	echo "Install X Window System Successful,Press any key to end..."
	char=`get_char`
 
 



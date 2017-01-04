#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

#Check OS
if [ -n "$(grep 'Aliyun Linux release' /etc/issue)" -o -e /etc/redhat-release ];then
    OS=CentOS
    [ -n "$(grep ' 7\.' /etc/redhat-release)" ] && CentOS_RHEL_version=7
    [ -n "$(grep ' 6\.' /etc/redhat-release)" -o -n "$(grep 'Aliyun Linux release6 15' /etc/issue)" ] && CentOS_RHEL_version=6
    [ -n "$(grep ' 5\.' /etc/redhat-release)" -o -n "$(grep 'Aliyun Linux release5' /etc/issue)" ] && CentOS_RHEL_version=5
elif [ -n "$(grep 'Amazon Linux AMI release' /etc/issue)" -o -e /etc/system-release ];then
    OS=CentOS
    CentOS_RHEL_version=6
elif [ -n "$(grep bian /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == 'Debian' ];then
    OS=Debian
    [ ! -e "$(which lsb_release)" ] && { apt-get -y update; apt-get -y install lsb-release; clear; }
    Debian_version=$(lsb_release -sr | awk -F. '{print $1}')
elif [ -n "$(grep Deepin /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == 'Deepin' ];then
    OS=Debian
    [ ! -e "$(which lsb_release)" ] && { apt-get -y update; apt-get -y install lsb-release; clear; }
    Debian_version=$(lsb_release -sr | awk -F. '{print $1}')
elif [ -n "$(grep Ubuntu /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == 'Ubuntu' -o -n "$(grep 'Linux Mint' /etc/issue)" ];then
    OS=Ubuntu
    [ ! -e "$(which lsb_release)" ] && { apt-get -y update; apt-get -y install lsb-release; clear; }
    Ubuntu_version=$(lsb_release -sr | awk -F. '{print $1}')
    [ -n "$(grep 'Linux Mint 18' /etc/issue)" ] && Ubuntu_version=16
else
    echo "${CFAILURE}Does not support this OS, Please contact the author! ${CEND}"
    kill -9 $$
fi

if [ $(getconf WORD_BIT) == 32 ] && [ $(getconf LONG_BIT) == 64 ];then
    OS_BIT=64
else
    OS_BIT=32
fi


#Collect Some Information From Users
while :; do echo
    read -p "Is this server located in China ? [y/n]: " serverlocation # We will use the NPM Source in China if this option is "y"
    if [[ ! $serverlocation =~ ^[y,n]$ ]];then
        echo "${CWARNING}input error! Please only input 'y' or 'n'${CEND}"
    else
        break
    fi
done

read -p "Please type in your domain(exp: ghost.com)" domain

#Install Node.js via Package Manager
if [ ${OS} == CentOS ];then
    yum -y install epel-release
	yum install wget unzip git tar -y
    curl --silent --location https://rpm.nodesource.com/setup_4.x | bash -
    yum install -y nodejs
else
    apt-get install wget git curl unzip tar p7zip -y
    curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
    apt-get install -y nodejs
fi

#Install Nginx via Oneinstack(https://github.com/lj2007331/oneinstack)
cd /root
wget https://github.com/lj2007331/oneinstack/archive/V1.4.tar.gz && tar -xf V1.4.tar.gz && cd oneinstack-1.4/
rm -rf install.sh && wget http://download.ipatrick.cn/ghost/install.sh && chmod +x install.sh
./install.sh

#Download the Ghost Blog
mkdir /data/wwwroot/ghost
cd /data/wwwroot/ghost
wget https://github.com/TryGhost/Ghost/releases/download/0.11.1/Ghost-0.11.1.zip && unzip Ghost-0.11.1.zip

#Change the NPM Source if the user choose to located in China
if [ $serverlocation == 'y' ];then
    npm config set registry https://registry.npm.taobao.org
fi
npm install --production

#Configure PM2 to keep the Ghost Blog alive all the time
npm install -g pm2
NODE_ENV=production pm2 start index.js --name "ghost"

if [ ${OS} == CentOS ];then
    pm2 startup centos
else
    pm2 startup ubuntu
fi
pm2 save



#Configure Nginx to set proxy to the Ghost Blog
mkdir /usr/local/nginx/conf/vhost/
cd /usr/local/nginx/conf/vhost/
touch ghost.conf
echo "server {  " > ghost.conf
echo "server_name $domain;" >> ghost.conf
echo "location / {" >> ghost.conf
echo "proxy_set_header   X-Real-IP \$remote_addr;" >> ghost.conf
echo "proxy_set_header   Host      \$http_host;" >> ghost.conf
echo "proxy_pass         http://127.0.0.1:2368;" >> ghost.conf
echo "}" >> ghost.conf
echo "}" >> ghost.conf

#Reload the Nginx to apply the chages to the Vhost
service nginx reload


#Clean useless things.
rm -rf /root/oneinstack-1.4
rm -rf /root/V1.4.tar.gz
rm -rf /data/wwwroot/ghost/Ghost-0.11.1.zip
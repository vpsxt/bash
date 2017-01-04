#!/bin/bash

function Welcome()
{
cd /root
clear
printf "                Service Time : " && date -R
echo "            ======================================================";
echo "            |                    serverSpeeder                   |";
echo "            |                                           Linux    |";
echo "            |----------------------------------------------------|";
echo "            |                                       -- By .Vicer |";
echo "            ======================================================";
echo "";
rootness;
}

function rootness()
{
if [[ $EUID -ne 0 ]]; then
   echo "Error:This script must be run as root!" 1>&2
   exit 1
fi
}

function pause()
{
read -n 1 -p "Press Enter to Continue..." INP
if [ "$INP" != '' ] ; then
echo -ne '\b \n'
echo "";
fi
}

function Check()
{
echo 'Preparatory work...'
apt-get >/dev/null 2>&1
[ $? -le '1' ] && apt-get -y -qq install wget curl grep unzip ethtool >/dev/null 2>&1
yum >/dev/null 2>&1
[ $? -le '1' ] && yum -y -q install which wget sed curl grep awk unzip ethtool >/dev/null 2>&1
[ -f /etc/redhat-release ] && KNA=$(awk '{print $1}' /etc/redhat-release)
[ -f /etc/os-release ] && KNA=$(awk -F'[= "]' '/PRETTY_NAME/{print $3}' /etc/os-release)
[ -f /etc/lsb-release ] && KNA=$(awk -F'[="]+' '/DISTRIB_ID/{print $2}' /etc/lsb-release)
KNB=$(getconf LONG_BIT)
Eth=$(ifconfig |grep -B1 "$(wget -qO- ipv4.icanhazip.com)" |awk '/eth/{ print $1 }')
[ -z "$Eth" ] && echo "I can not find the server pubilc Ethernet! " && exit 1
MyKernel=$(curl -k -q --progress-bar 'https://raw.githubusercontent.com/0oVicero0/serverSpeeder_kernel/master/serverSpeeder.txt' |grep "$KNA/" |grep "/x$KNB/" |grep "/$(uname -r)/" |sort -k3 -t '_' |tail -n 1)
[ -z "$MyKernel" ] && echo "The shell scripts only support some kernel released for Linux!" && exit 1
pause;
}

function SelectKernel()
{
KNN=$(echo $MyKernel |awk -F '/' '{ print $2 }') && [ -z "$KNN" ] && Unstall && echo "Error,Not Found! " && exit 1
KNK=$(echo $MyKernel |awk -F '/' '{ print $3 }') && [ -z "$KNK" ] && Unstall && echo "Error,Not Found! " && exit 1
KNV=$(echo $MyKernel |awk -F '/' '{ print $5 }') && [ -z "$KNV" ] && Unstall && echo "Error,Not Found! " && exit 1
wget --no-check-certificate -q -O "/root/appex/apxfiles/bin/acce-"$KNV"-["$KNA"_"$KNN"_"$KNK"]" "https://raw.githubusercontent.com/0oVicero0/serverSpeeder_kernel/master/$MyKernel"
[ ! -f "/root/appex/apxfiles/bin/acce-"$KNV"-["$KNA"_"$KNN"_"$KNK"]" ] && Unstall && echo "Download Error,Not Found acce-$KNV-[$KNA_$KNN_$KNK]! " && exit 1
}

function Install()
{
Welcome;
Check;
ServerSpeeder;
dl-Lic;
bash /root/appex/install.sh
rm -rf /root/appex* >/dev/null 2>&1
clear
bash /appex/bin/serverSpeeder.sh status
exit 0
}

function Unstall()
{
[ -d /etc/rc.d ] && rm -rf /etc/rc.d/init.d/serverSpeeder >/dev/null 2>&1
[ -d /etc/rc.d ] && rm -rf /etc/rc.d/rc2.d/*serverSpeeder >/dev/null 2>&1
[ -d /etc/rc.d ] && rm -rf /etc/rc.d/rc3.d/*serverSpeeder >/dev/null 2>&1
[ -d /etc/rc.d ] && rm -rf /etc/rc.d/rc4.d/*serverSpeeder >/dev/null 2>&1
[ -d /etc/rc.d ] && rm -rf /etc/rc.d/rc5.d/*serverSpeeder >/dev/null 2>&1
[ -d /etc/rc.d ] && rm -rf /etc/rc.d/rc0.d/*serverSpeeder >/dev/null 2>&1
[ -d /etc/rc.d ] && rm -rf /etc/rc.d/rc1.d/*serverSpeeder >/dev/null 2>&1
[ -d /etc/rc.d ] && rm -rf /etc/rc.d/rc6.d/*serverSpeeder >/dev/null 2>&1
[ -d /etc/init.d ] && rm -rf /etc/init.d/serverSpeeder >/dev/null 2>&1
[ -d /etc/init.d ] && rm -rf /etc/rc2.d/*serverSpeeder >/dev/null 2>&1
[ -d /etc/init.d ] && rm -rf /etc/rc3.d/*serverSpeeder >/dev/null 2>&1
[ -d /etc/init.d ] && rm -rf /etc/rc4.d/*serverSpeeder >/dev/null 2>&1
[ -d /etc/init.d ] && rm -rf /etc/rc5.d/*serverSpeeder >/dev/null 2>&1
[ -d /etc/init.d ] && rm -rf /etc/rc0.d/*serverSpeeder >/dev/null 2>&1
[ -d /etc/init.d ] && rm -rf /etc/rc1.d/*serverSpeeder >/dev/null 2>&1
[ -d /etc/init.d ] && rm -rf /etc/rc6.d/*serverSpeeder >/dev/null 2>&1
rm -rf /etc/serverSpeeder.conf >/dev/null 2>&1
chattr -R -i /appex >/dev/null 2>&1
rm -rf /appex >/dev/null 2>&1
rm -rf /root/appex* >/dev/null 2>&1
echo 'serverSpeeder have been removed! '
exit 0
}

function dl-Lic()
{
chattr -R -i /appex >/dev/null 2>&1
rm -rf /appex >/dev/null 2>&1
mkdir -p /appex/etc
mkdir -p /appex/bin
MAC=$(ifconfig "$Eth" |awk '/HWaddr/{ print $5 }')
wget --no-check-certificate -q -O "/appex/etc/apx.lic" "http://serverspeeder.azurewebsites.net/lic?mac=$MAC"
SIZE=$(du -b /appex/etc/apx.lic |awk '{ print $1 }')
if [[ $SIZE == '0' ]]; then
echo "Lic download error, try again! "
echo "Please wait..."
sleep 7;
dl-Lic;
else
echo "Lic download success! "
chattr +i /appex/etc/apx.lic
rm -rf /appex/bin/ethtool >/dev/null 2>&1
cp -f $ethtooldir /appex/bin
fi
}

function ServerSpeeder()
{
[ -n $(which ethtool) ] && ethtooldir=$(which ethtool)
[ ! -f /root/appex.zip ] && wget --no-check-certificate -q -O "/root/appex.zip" "https://raw.githubusercontent.com/0oVicero0/serverSpeeser_Install/master/appex.zip"
[ ! -f /root/appex.zip ] && Unstall && echo "Error,Not Found appex.zip! " && exit 1
mkdir -p /root/appex
unzip -o -d /root/appex /root/appex.zip
SelectKernel;
APXEXE=$(ls -1 /root/appex/apxfiles/bin |grep 'acce-')
sed -i "s/^accif\=.*/accif\=\"$Eth\"/" /root/appex/apxfiles/etc/config
sed -i "s/^apxexe\=.*/apxexe\=\"\/appex\/bin\/$APXEXE\"/" /root/appex/apxfiles/etc/config
}

[ $# == '1' ] && [ "$1" == 'install' ] && Install;
[ $# == '1' ] && [ "$1" == 'unstall' ] && Welcome && pause && Unstall;
echo -ne "Usage:\n     bash $0 [install|unstall]\n"


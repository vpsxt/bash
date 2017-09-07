wget -c -N --no-check-certificate https://raw.githubusercontent.com/vpsxt/bash/master/domian/DomainMegaBot-master.zip

unzip DomainMegaBot-master.zip

cd DomainMegaBot-master

yum -y install gcc

gcc -o DomainMegaBot DomainMegaBot.c

./DomainMegaBot

然后选择你要查询的后缀

选择你要扫域名的字典.









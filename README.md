# 简介 #

----------

  本仓库主要收集一些网友制作的一键包,大部分也都是在github上可以找到的.
都是开源的,为了方便,我都收集在这里,尽量把安装介绍写的详细点,有任何疑问请联系我.

- 沃园:[http://www.woyard.com](http://www.woyard.com "http://www.woyard.com")
- QQ:78025108 QQ群:253510359


----------

-  bench.sh

作用:测试VPS基础信息，以及下载速度

----------
- da1443.sh

DirectAdmin 1.44.3 开心版x86/x64 + Capri 皮肤一键安装

----------


- 5hadows0cks-all.sh

一键安装ss服务器端4合1版本，自主选择：python版、R版(推荐)、go版、libev版(省内存)。


----------
 

- serverspeeder.sh

一键安装锐速破解全功能版，不支持openvz架构(91yun.org)

----------
- serverspeeder_appex.sh

另一位爱好者开发的锐速一键安装脚本，开发：https://github.com/0oVicero0/serverSpeeser_Install


----------
- finalspeed.sh

一键安装finalspeed功能，支持全系架构

----------
- l2tp.sh

一键安装l2tp的vpn服务器端，输入3个指令即可

----------
- AutoBackupToFtp.sh

每天自动备份MYSQL及打包网站目录


----------
- unixbench.sh

unixbench进行跑分测试，单核和多核不同跑分.


----------
-  vhwinfo.sh

一个测试vps信息的脚本.
使用方法:


wget --no-check-certificate https://raw.githubusercontent.com/vpsxt/bash/master/vhwinfo.sh -O - -o /dev/null|bash

或者按照文本最底下方法使用.

----------
- xwindow.sh

给你的linux装个桌面，适用于centos系统.


----------
SSR-Bash-Python The Final Version 最终版

本版特性：

1. 加入 auth_chain_b 支持
2. 实现离线化安装
3. 附赠客户端（安卓，PC）


安装指令：

    yum install unzip wget #For Centos
    apt install unzip wget #For Debian

再执行一下命令:
    `wget -c --no-check-certificate https://raw.githubusercontent.com/vpsxt/bash/master/ssr.zip && unzip ssr.zip && cd SSR* && bash install.sh`

----------
使用virt-what判断VPS虚拟化技术

首先安装程序依赖:

    yum -y install gcc-c++

####安装 ####

    wget --no-check-certificate https://raw.githubusercontent.com/vpsxt/bash/master/virt-what-1.11.tar.gz
    tar zxf virt-what-1.11.tar.gz   #解压缩包
    cd virt-what-1.11   #进入目录
    ./configure #按默认设置
    make && make install#编译并安装

####查看####

    virt-what

如果显示下面这样的就说明成功地测试到了vps的架构为openvz
[root@localhost virt-what-1.11]# virt-what
openvz

这个工具可以检查到以下虚拟化创建的VPS：

vmware、hyper-v、virtualpc、virtualbox、openvz / virtuozzo、linux-vserver、uml、ibm powervm lx86 linux/x86 emulator、hitachi virtualization manager (hvm) virtage logical 、partitioning、ibm systemz、parallels、xen、qemu/kvm
----------
检查vps是何种架构

    wget –N —no–check–certificate 
    https://raw.githubusercontent.com/vpsxt/bash/master/vm_check.sh && bash vm_check.sh

其实是和上面virt-what一样,只是简便一点而已.

----------
domainmegabot的安装和使用:





----------



- **使用方法**

wget --no-check-certificate https://raw.githubusercontent.com/vpsxt/bash/master/yourbash.sh

chmod +x yourbash.sh

./yourbash.sh



#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export PATH
yum install -y gcc gcc-c++ gdb
wget http://people.redhat.com/~rjones/virt-what/files/virt-what-1.12.tar.gz
tar zxvf virt-what-1.12.tar.gz
cd virt-what-1.12/
./configure
make && make install
virt-what

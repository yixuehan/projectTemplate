#!/bin/bash
if [ $MKOSTYPE == 'centos' ]
then
        sudo yum install mysql-devel -y
    # sudo yum install rh-mysql80-mysql-devel -y
elif [ $MKOSTYPE == 'ubuntu' ]
then
    sudo apt install libmysqlclient-dev
    if [ ! 0 -eq $? ]
    then
       exit 1
    fi
fi
if [ ! 0 -eq $? ]
then
    exit 1
fi
version=3.2.4
cd ../download_tmp
if [ ! -f mysql++-${version}.tar.gz ]
then
    wget https://tangentsoft.com/mysqlpp/releases/mysql++-${version}.tar.gz
    if [ ! $? -eq 0 ]
    then
        rm -rf mysql++-${version}.tar.gz
        exit 1
    fi
    tar -xf mysql++-${version}.tar.gz
fi
cd mysql++-${version}
./configure --prefix=${HOME}/usr --enable-shared=no --enable-static=yes
make install

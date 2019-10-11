#!/bin/bash
if [ $# -lt 1 ]
then
    echo usage:$0 install_dir
    exit 1
fi
install_dir=$1

if [ $MKOSTYPE == 'centos' ]
then
        sudo yum install mysql-devel -y
    # sudo yum install rh-mysql80-mysql-devel -y
elif [ $MKOSTYPE == 'ubuntu' ]
then
    sudo apt install -y libmysqlclient-dev
    # sudo apt install -y libmariadbclient-dev
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
fi
rm -rf mysql++-${version}
tar -xf mysql++-${version}.tar.gz
cd mysql++-${version}
if [ ! -d ${install_dir} ]
then
    mkdir -p ${install_dir}
fi
./configure --prefix=${install_dir} --enable-shared=no --enable-static=yes
make && make install

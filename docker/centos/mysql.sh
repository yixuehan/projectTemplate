#!/bin/bash
version=3.2.4
if [ ! -f mysql++-${version}.tar.gz ]
then
    wget https://tangentsoft.com/mysqlpp/releases/mysql++-${version}.tar.gz
    tar -xf mysql++-${version}.tar.gz
fi
cd mysql++-${version}
./configure --prefix=/install/mysql --enable-shared=no --enable-static=yes
make install
if [ 0 -eq $? ]
then
    cd ..
    rm -rf mysql++-${version}.tar.gz
    rm -rf mysql++-${version}
fi

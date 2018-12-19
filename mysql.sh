#!/bin/bash
version=3.2.4
rm -rf mysql++-${version}.tar.gz
rm -rf mysql++-${version}
wget https://tangentsoft.com/mysqlpp/releases/mysql++-${version}.tar.gz
tar -xf mysql++-${version}.tar.gz
cd mysql++-${version}
./configure --prefix=${HOME}/usr --enable-shared=no --enable-static=yes
#make
make install
cd ..
rm -rf mysql++-${version}.tar.gz
rm -rf mysql++-${version}

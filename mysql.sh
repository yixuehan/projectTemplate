#!/bin/bash
version=3.2.4
wget https://tangentsoft.com/mysqlpp/releases/mysql++-${version}.tar.gz
tar -xf mysql++-${version}.tar.gz
cd mysql++-${version}
./configure --prefix=${HOME}/usr
make install

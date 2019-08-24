#!/bin/bash
version=3.5
if [ ! -f ccache-${version}.tar.gz ]
then
    wget https://www.samba.org/ftp/ccache/ccache-${version}.tar.gz
    tar -xf ccache-${version}.tar.gz
fi
cd ccache-${version}
./configure --prefix=${HOME}/usr
make install
if [ 0 -eq $? ]
then
    cd ..
    rm -rf ccache-${version}.tar.gz ccache-${version}
fi

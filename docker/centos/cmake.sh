#!/bin/bash
version=3.13.1
if [ ! -f cmake-${version}.tar.gz ]
then
    wget https://github.com/Kitware/CMake/releases/download/v${version}/cmake-${version}.tar.gz
    if [ ! $? -eq 0 ]
    then
        rm -rf cmake-${version}.tar.gz
        exit 1
    fi
    tar -xf cmake-${version}.tar.gz
fi
cd cmake-${version}
./configure --prefix=/install/cmake && gmake && make install
if [ $? -eq 0 ]
then
    cd ../
    rm -rf cmake-${version}.tar.gz cmake-${version}
fi

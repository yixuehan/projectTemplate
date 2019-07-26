#!/bin/bash
version=3.13.4
cd download_tmp
if [ ! -f "cmake-${version}.tar.gz" ]
then
    wget https://github.com/Kitware/CMake/releases/download/v${version}/cmake-${version}.tar.gz
    tar -xf cmake-${version}.tar.gz
fi
cd cmake-${version}

case $MKOSTYPE in
    ubuntu)
        ./configure --prefix=${HOME}/usr && make install
        ;;
    centos)
        ./configure --prefix=${HOME}/usr && gmake && make install
        ;;
    *)
        echo unknown sys
        ;;
esac

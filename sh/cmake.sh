#!/bin/bash
version=3.14.1
version=3.13.4
cd ../download_tmp
if [ ! -f "cmake-${version}.tar.gz" ]
then
    wget https://github.com/Kitware/CMake/releases/download/v${version}/cmake-${version}.tar.gz
    tar -xf cmake-${version}.tar.gz
fi
cd cmake-${version}

install_dir=${HOME}/usr/cmake

case $MKOSTYPE in
    ubuntu)
        ./configure --prefix=${install_dir} && make install
        ;;
    centos|docker_centos)
        ./configure --prefix=${install_dir} && gmake && make install
        ;;
    *)
        echo unknown sys
        ;;
esac

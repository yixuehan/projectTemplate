#!/bin/bash
if [ $# -lt 1 ]
then
    echo usage:$0 install_dir
    exit 1
fi
install_dir=$1
version=3.14.1
version=3.13.4
cd ../download_tmp
if [ ! -f "cmake-${version}.tar.gz" ]
then
    wget https://github.com/Kitware/CMake/releases/download/v${version}/cmake-${version}.tar.gz
fi
rm -rf cmake-${version}
tar -xf cmake-${version}.tar.gz
cd cmake-${version}

case $MKOSTYPE in
    ubuntu|alpine)
        ./configure --prefix=${install_dir} && make install
        ;;
    centos|docker_centos)
        ./configure --prefix=${install_dir} && gmake && make install
        ;;
    *)
        echo unknown sys
        ;;
esac

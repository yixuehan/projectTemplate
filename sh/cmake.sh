#!/bin/bash
if [ $# -lt 1 ]
then
    echo usage:$0 install_dir
    exit 1
fi
install_dir=$1
#version=3.14.1
version=3.18.1
cd ../download_tmp
if [ ! -f "cmake-${version}.tar.gz" ]
then
    download_url=https://github.com/Kitware/CMake/releases/download/v${version}/cmake-${version}.tar.gz
    # echo ${download_url}
    # echo https://github.com/Kitware/CMake/releases/download/v3.16.2/cmake-3.16.2.tar.gz
    wget ${download_url}
    if [ $? -gt 0 ]
    then
        echo 下载[cmake-${version}.tar.gz]失败
        rm -rf cmake-${version}.tar.gz
        exit 1
    fi
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

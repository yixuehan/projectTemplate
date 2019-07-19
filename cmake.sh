#!/bin/bash
version=3.13.4
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

if [ $? -eq 0 ]
then
    cd ../
    # rm -rf cmake-${version}.tar.gz cmake-${version}
fi

#!/bin/bash

if [ ${PRONAME}x == ""x ]
then
    echo 请先设置[PRONAME]
    exit 1
fi

sudo apt install cmake -y

#设置mak、shell路径`
shellpath=$PWD

pull()
{
   cd ${PRONAME}
   mkdir ${PRONAME}/bin ${PRONAME}/log ${PRONAME}/lib ${PRONAME}/include ${PRONAME}/src ${PRONAME}/etc
   #git submodule add https://github.com/yixuehan/makeTemplate.git
   #git submodule add https://github.com/boostorg/boost.git
   #git submodule add https://github.com/grpc/grpc.git
   cd ${shellpath}
   git pull
   git submodule update --init --recursive
   git pull --recurse-submodules
}

# 编译boost
boost()
{
    echo 编译boost...
    cd $shellpath/boost
    ./bootstrap.sh --libdir=${HOME}/usr/lib --includedir=${HOME}/usr/include
    ./bjam cxxflags="-std=c++1z" variant=release install
}

# 编译grpc
grpc()
{
    echo 编译grpc...
    sudo apt-get install build-essential autoconf libtool pkg-config -y
    sudo apt-get install libgflags-dev libgtest-dev -y
    sudo apt-get install clang libc++-dev -y
    cd $shellpath/grpc
    make && make install prefix=${HOME}/usr
    cd $shellpath/grpc/third_party/protobuf
    make && make install prefix=${HOME}/usr
}

# 编译json
json()
{
    echo 编译json...
    cd $shellpath/json
    rm -rf build
    mkdir build
    cd build
    cmake -DCMAKE_INSTALL_PREFIX=${HOME}/usr ..
    make install
}

echo $*
for library in $* ; do
    echo $library
    eval "${library}"
done

#提示
echo 在.bashrc中增加:
echo 'export MKHOME=${HOME}/makeTemplate/mak'
echo '. ${HOME}/projectTemplate/env/env.sh'

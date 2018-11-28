#!/bin/bash

if [ ${PRONAME}x == ""x ]
then
    echo 请先设置[PRONAME]
    exit 1
fi

#设置mak、shell路径`
shellpath=$PWD/$(dirname $0)

cd ${PRONAME}
mkdir ${PRONAME}/bin ${PRONAME}/log ${PRONAME}/lib ${PRONAME}/include ${PRONAME}/src ${PRONAME}/etc
#git submodule add https://github.com/yixuehan/makeTemplate.git
#git submodule add https://github.com/boostorg/boost.git
#git submodule add https://github.com/grpc/grpc.git
git submodule update --init --recursive


# 编译boost
cd $shellpath/boost
./bootstrap.sh --libdir=${HOME}/usr/lib --includedir=${HOME}/usr/include
./bjam cxxflags="-std=c++1z" variant=release install

# 编译grpc
sudo apt-get install build-essential autoconf libtool pkg-config -y
sudo apt-get install libgflags-dev libgtest-dev -y
sudo apt-get install clang libc++-dev -y
cd $shellpath/grpc
make && make install prefix=${HOME}/usr
cd $shellpath/grpc/third_party/protobuf
make && make install prefix=${HOME}/usr

#提示
echo 在.bashrc中增加:
echo export MKHOME='${PRONAME}/makeTemplate/mak'
echo '. ${PRONAME}/projectTemplate/etc/env.sh'

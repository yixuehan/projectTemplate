#!/bin/bash

if [ ${PRONAME}x == ""x ]
then
    echo 请先设置[PRONAME]
    exit 1
fi

#设置mak、shell路径`
shellpath=$PWD/$(dirname $0)
mkhome=$shellpath/makeTemplate

cd ${PRONAME}
mkdir ${PRONAME}/bin ${PRONAME}/log ${PRONAME}/lib ${PRONAME}/include ${PRONAME}/src ${PRONAME}/etc
cd $shellpath
#git submodule add https://github.com/boostorg/boost.git
git submodule update --init --recursive

# 编译boost
cd $shellpath/boost
./bootstrap.sh --libdir=${HOME}/usr/lib --includedir=${HOME}/usr/include
./bjam cxxflags="-std=c++1z" variant=release install

#提示
oldpath=$mkhome
cd $mkhome
mkhome=$PWD
cd $oldpath
echo 在.bashrc中增加:
echo export MKHOME='${PRONAME}/makeTemplate/mak'
echo '. ${PRONAME}/projectTemplate/etc/env.sh'

#!/bin/bash

#设置mak、shell路径`
shellpath=$PWD/$(dirname $0)
mkhome=$shellpath/makeTemplate

cd $shellpath
mkdir ${PRONAME}/bin ${PRONAME}/log ${PRONAME}/lib ${PRONAME}/include ${PRONAME}/src ${PRONAME}/etc
git submodule add https://github.com/yixuehan/makeTemplate.git
git submodule add https://github.com/boostorg/boost.git
git submodule update --init --recursive

# 编译boost
cd $shellpath/boost
./bootstrap.sh --libdir=${PRONAME}/lib --includedir=${PRONAME}/include
./bjam cxxflags="-std=c++1z" variant=release install

#拷贝配置文件
cp -i ${mkhome}/etc/env.sh ${PRONAME}/etc/env.sh
rm -ri ${PRONAME}/mak
cp -R ${mkhome} ${PRONAME}/mak

#提示
oldpath=$mkhome
cd $mkhome
mkhome=$PWD
cd $oldpath
echo 在.bashrc中增加:
echo export MKHOME=${PRONAME}/mak
echo . ${PRONAME}/etc/env.sh

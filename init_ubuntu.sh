#!/bin/bash

shellpath=$PWD/$(dirname $0)
cd $shellpath
mkdir ${PRONAME}/bin ${PRONAME}/log ${PRONAME}/lib ${PRONAME}/include ${PRONAME}/src ${PRONAME}/etc
git submodule update --init --recursive

# 编译boost
cd $shellpath/boost
git submodule update --recursive
./bootstrap.sh --libdir=${PRONAME}/lib --includedir=${PRONAME}/include
./bjam cxxflags="-std=c++1z" variant=release install

#设置mak路径
mkhome=$shellpath/makeTemplate
oldpath=$mkhome
cd $mkhome
mkhome=$PWD
cd $oldpath
echo 增加[export MKHOME=$mkhome]
echo 加载[. ${mkhome}/etc/env.sh]

#!/bin/bash
src=scons-3.0.3
PYTHON=python
if [ ! -e ${src}.tar.gz ]
then
    wget http://prdownloads.sourceforge.net/scons/${src}.tar.gz
    tar -xf ${src}.tar.gz
fi
cd ${src}
$PYTHON setup.py install --prefix=/install/scons
if [ $? -eq 0 ]
then
    rm -rf ${src}
    rm -rf ${src}.tar.gz
fi

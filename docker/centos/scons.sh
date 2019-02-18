#!/bin/bash
PYTHON=/usr/bin/python && \
MYSCONS=/src/scons/src && \
$PYTHON $MYSCONS/script/scons.py && \
$PYTHON bootstrap.py build/scons && \
cd build/scons && \
$PYTHON setup.py install --prefix=/install/scons

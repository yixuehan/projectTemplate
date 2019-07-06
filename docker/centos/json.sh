#!/bin/bash
. ~/.bashrc

rm -rf build
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/install/json ..
make install





#!/bin/bash
version=3.13.1
rm -rf cmake-${version}.tar.gz
wget https://github.com/Kitware/CMake/releases/download/v${version}/cmake-${version}.tar.gz
rm -rf cmake-${version}
tar -xf cmake-${version}.tar.gz
cd cmake-${version}
./configure && gmake && sudo make install
cd ../
rm -rf cmake-${version}.tar.gz cmake-${version}

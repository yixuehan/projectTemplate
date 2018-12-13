#!/bin/bash

wget https://github.com/Kitware/CMake/releases/download/v3.13.1/cmake-3.13.1.tar.gz
tar -xf cmake-3.13.1.tar.gz
cd cmake-3.13.1
mkdir build
cd build
cmake .. && sudo make install

wget https://www.samba.org/ftp/ccache/ccache-3.5.tar.gz
tar -xf ccache-3.5.tar.gz
cd ccache-3.5
./configure
sudo make install


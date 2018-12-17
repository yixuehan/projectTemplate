#!/bin/bash
version=3.5
rm -rf ccache-${version}.tar.gz
wget https://www.samba.org/ftp/ccache/ccache-${version}.tar.gz
rm -rf ccache-${version}
tar -xf ccache-${version}.tar.gz
cd ccache-${version}
./configure
sudo make install
cd ..
rm -rf ccache-${version}.tar.gz ccache-${version}

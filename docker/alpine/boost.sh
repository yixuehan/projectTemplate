#!/bin/bash
./bootstrap.sh --libdir=/install/boost/lib --includedir=/install/boost/include
./bjam cxxflags="-std=c++1z" variant=release install

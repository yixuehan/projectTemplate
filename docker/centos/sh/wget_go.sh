#!/bin/bash
shellpath=$(dirname $(realpath $0))
cd ${shellpath}/../download_tmp
version=1.12.7
if [ ! -f go${version}.linux-amd64.tar.gz ]
then
    wget https://dl.google.com/go/go${version}.linux-amd64.tar.gz
    if [ ! $? -eq 0 ] 
    then
        rm -f go${version}.linux-amd64.tar.gz
        exit 1
    fi  
    if [ -d go ]
    then
        rm -rf go
    fi  
    tar -xf go${version}.linux-amd64.tar.gz
fi

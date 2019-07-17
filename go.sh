#!/bin/bash

if [ ${MKOSTYPE}x == 'x' ]
then
    echo unknown OSTYPE
    return 1
fi

version=1.12.7

cd download_tmp
# https://dl.google.com/go/go1.12.6.linux-amd64.tar.gz
if [ ! -f go${version}.linux-amd64.tar.gz ]
then
    wget https://dl.google.com/go/go${version}.linux-amd64.tar.gz
    if [ ! $? -eq 0 ]
    then
        rm -f go${version}.linux-amd64.tar.gz
        exit 1
    fi
    tar -xf go${version}.linux-amd64.tar.gz
fi

if [ $MKOSTYPE == 'centos' ]
then
    sudo mv /usr/lib/golang /usr/lib/golang.bak
    sudo mv go /usr/lib/golang
elif [ $MKOSTYPE == 'ubuntu' ]
then
    target=/usr/lib/go-${version}
    sudo rm -rf ${target}
    sudo mv go ${target}
    sudo ln -s ${target} /usr/lib/go -f
    sudo ln -s ${target}/bin/go /usr/bin/go -f

fi

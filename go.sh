#!/bin/bash

version=1.12.6

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

sudo mv /usr/lib/golang /usr/lib/golang.bak
sudo mv go /usr/lib/golang

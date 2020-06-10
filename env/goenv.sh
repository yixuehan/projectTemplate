#!/bin/bash

#export GOCACHE=off
export GOPATH=${HOME}/gopath
export GOFLAGS="-count=1"
export GOBIN=${GOPATH}/bin
export GOSRC=${GOPATH}/src
export PATH=$PATH:$GOPATH/bin

# Enable the go modules feature
export GO111MODULE=on
# export GO111MODULE=auto
# Set the GOPROXY environment variable
#export GOPROXY=https://goproxy.io,direct
export GOPROXY=https://goproxy.io
#export GOPROXY=https://proxy.golang.org,direct

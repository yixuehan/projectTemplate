#!/bin/bash

#export GOCACHE=off
export GOPATH=${HOME}/go
export GOFLAGS="-count=1"
export GOBIN=${GOPATH}/bin
export GOSRC=${GOPATH}/src
export PATH=$PATH:$GOPATH/bin

# Enable the go modules feature
export GO111MODULE=on
# Set the GOPROXY environment variable
export GOPROXY=https://goproxy.io

#!/bin/bash

#export GOCACHE=off
export GOFLAGS="-count=1"
export GOBIN=${GOPATH}/bin
export GOSRC=${GOPATH}/src
export PATH=$PATH:$GOPATH/bin


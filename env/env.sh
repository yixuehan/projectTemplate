#!/bin/bash
if [ -e '/etc/centos-release' ]
then
    MKOSTYPE=centos
else
    MKOSTYPE=$(echo `lsb_release -a 2>/dev/null |grep -i distributor| tr A-Z a-z|cut -d':' -f2`)
fi
export MKOSTYPE

export OPENCL_INCLUDE_PATH=/opt/intel/opencl/include
export OPENCL_LIBRARY_PATH=/opt/intel/opencl

CPLUS_INCLUDE_PATH=${CPLUS_INCLUDE_PATH}:${OPENCL_INCLUDE_PATH}
CPLUS_INCLUDE_PATH=${CPLUS_INCLUDE_PATH}

LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${OPENCL_LIBRARY_PATH}

LIBRARY_PATH=$LD_LIBRARY_PATH

PATH=$PATH:${PRONAME}/bin:${HOME}/usr/bin:${PRONAME}/src/python/interface

PS1='[\u@\h \W]\$ '

export CPLUS_INCLUDE_PATH
export LD_LIBRARY_PATH
export LIBRARY_PATH
export PATH
export PS1

export MKHOME=${HOME}/projectTemplate/mak
export PYTHONPATH=$PYTHONPATH:${HOME}/usr/lib/python3.6/site-packages

export NUM_CPU=`cat /proc/cpuinfo | grep "processor" | wc -l`

#export MANPATH=/home/wangkai/project/thirdLib/${MKOSTYPE}/google_coredumper/man

alias cds='cd $PRONAME/src'
alias cdi='cd $PRONAME/include'
alias cdm='cd ${HOME}/projectTemplate/mak'
alias cde='cd ${HOME}/projectTemplate/env'
alias cdl='cd $PRONAME/log'
alias cdb='cd $PRONAME/bin'
alias cdp='cd $PRONAME'
alias cdlib='cd $PRONAME/lib'
alias cpmake='cp ${HOME}/projectTemplate/mak/build.sh . && chmod +x build.sh'
alias rm='rm -i'

function cd()
{
    builtin cd $@ && ls
}

ulimit -c unlimited

# devtoolset-7
if [ 1 -eq $SHLVL ] && [ $MKOSTYPE = "centos" ]
then
    scl enable devtoolset-7 bash
fi

which ccache &> /dev/null
if [ 0 -eq $? ]
then
    export CCACHE_DIR=/tmp/ccache
    ccache --max-size=10G > /dev/null
    export CCACHE_SIZE=10G # redundant; set anyway
    export CCACHE_UMASK=0 # shared to world
fi

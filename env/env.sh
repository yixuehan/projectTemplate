#!/bin/bash
if [ -e '/etc/centos-release' ]
then
    MKOSTYPE=centos
    PYTHON=python36
else
    MKOSTYPE=$(echo `lsb_release -a 2>/dev/null |grep -i distributor| tr A-Z a-z|cut -d':' -f2`)
fi
export MKOSTYPE

export OPENCL_INCLUDE_PATH=/opt/intel/opencl/include
export OPENCL_LIBRARY_PATH=/opt/intel/opencl

CPLUS_INCLUDE_PATH=${CPLUS_INCLUDE_PATH}:${OPENCL_INCLUDE_PATH}
CPLUS_INCLUDE_PATH=${CPLUS_INCLUDE_PATH}

LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${OPENCL_LIBRARY_PATH}:~/usr/lib

LIBRARY_PATH=$LD_LIBRARY_PATH:~/usr/lib

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

function cleandocker()
{
    images=$(docker images | grep "<none>" | awk '{print $3}')
    docker rmi ${images}
}

function cd()
{
    builtin cd $@ && ls
}

function vimcpp()
{
    ln -s ${HOME}/projectTemplate/cpp.vimrc ~/.vimrc -f
}

function vimgo()
{
    ln -s ${HOME}/projectTemplate/go.vimrc ~/.vimrc -f
}

unalias vi
unalias vim

function vi()
{
    f=$1
    _vi=`which vi`
    echo $MKOSTYPE
    if [ $MKOSTYPE = 'centos' ]
    then
        ${_vi} $@
        return $?
    fi
    case ${f##*.} in
        go) 
            ln -s ${HOME}/projectTemplate/go.vimrc ~/.vimrc -f
            #fvim=${HOME}/projectTemplate/go.vimrc
            ;;
        h|hpp|cpp|c|ipp) 
            ln -s ${HOME}/projectTemplate/cpp.vimrc ~/.vimrc -f
            #fvim=${HOME}/projectTemplate/cpp.vimrc
            ;;
        *)
            ln -s ${HOME}/projectTemplate/cpp.vimrc ~/.vimrc -f
            #echo ${f##*.}
            #fvim=${HOME}/projectTemplate/base.vimrc
            ;;
    esac
    #echo ${fvim}
    ${_vi} $@
}

function vim()
{
    vi $@
}

ulimit -c unlimited

# devtoolset-7
if [ 1 -eq $SHLVL ] && [ $MKOSTYPE = "centos" ]
then
    export PATH=/opt/rh/devtoolset-7/root/bin:$PATH
    export PATH=/opt/rh/rh-python36/root/bin:$PATH
    # scl enable devtoolset-7 bash
fi

#if [ 4 -eq $SHLVL ] && [ $MKOSTYPE = "centos" ]
#then
#    scl enable rh-${PYTHON} bash
#fi

which ccache &> /dev/null
if [ 0 -eq $? ]
then
    export CCACHE_DIR=/tmp/ccache
    ccache --max-size=10G > /dev/null
    export CCACHE_SIZE=10G # redundant; set anyway
    export CCACHE_UMASK=0 # shared to world
fi

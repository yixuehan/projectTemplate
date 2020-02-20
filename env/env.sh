#!/bin/bash

repo=~/projectTemplate

if [ -e '/etc/centos-release' ]
then
    MKOSTYPE=centos
    PYTHON=python3
else
    MKOSTYPE=$(echo `lsb_release -a 2>/dev/null |grep -i distributor| tr A-Z a-z|cut -d':' -f2`)
fi
export MKOSTYPE

export OPENCL_INCLUDE_PATH=/opt/intel/opencl/include
export OPENCL_LIBRARY_PATH=/opt/intel/opencl

C_INCLUDE_PATH=${C_INCLUDE_PATH}:${OPENCL_INCLUDE_PATH}
export C_INCLUDE_PATH=${C_INCLUDE_PATH}:~/usr/boost/include
export C_INCLUDE_PATH=${C_INCLUDE_PATH}:~/projectTemplate/util/cpp
export C_INCLUDE_PATH=${C_INCLUDE_PATH}:~/usr/mysql/include
export C_INCLUDE_PATH=${C_INCLUDE_PATH}:~/usr/json/include
export C_INCLUDE_PATH=${C_INCLUDE_PATH}:~/usr/jsoncpp/include
export C_INCLUDE_PATH=${C_INCLUDE_PATH}:~/usr/FFmpeg/include
export C_INCLUDE_PATH=${C_INCLUDE_PATH}:~/usr/spdlog/include

export CPLUS_INCLUDE_PATH=${CPLUS_INCLUDE_PATH}:${C_INCLUDE_PATH}

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/usr/boost/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/usr/mysql/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${OPENCL_LIBRARY_PATH}
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/usr/jsoncpp/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/usr/FFmpeg/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/usr/spdlog/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/usr/lib

export LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib64/mysql:.

export PATH=$PATH:${PRONAME}/bin:${HOME}/usr/bin:${PRONAME}/src/python/interface:${HOME}/util/python

export PS1='[\u@\h \W]\$ '

export MKHOME=${repo}/mak
# export PYTHONPATH=$PYTHONPATH:${HOME}/usr/lib/python3.6/site-packages:${HOME}/gencode
export PYTHONPATH=$PYTHONPATH:${HOME}/usr/lib/python3.6/site-packages
export PYTHONPATH=$PYTHONPATH:${HOME}/gencode

export NUM_CPU=`cat /proc/cpuinfo | grep "processor" | wc -l`

export PKG_CONFIG_PATH=${HOME}/usr/lib/pkgconfig

#export MANPATH=/home/wangkai/project/thirdLib/${MKOSTYPE}/google_coredumper/man

alias cds='cd $PRONAME/src'
alias cdi='cd $PRONAME/include'
alias cdm='cd ${repo}/mak'
alias cde='cd ${repo}/env'
alias cdl='cd $PRONAME/log'
alias cdb='cd $PRONAME/bin'
alias cdp='cd $PRONAME'
alias cdlib='cd $PRONAME/lib'
alias cpmake='cp ${repo}/mak/build.sh . && chmod +x build.sh'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias docker++='docker run --rm -v${PWD}:/workdir -w/workdir w505703394/centos:dev g++ -std=c++2a -Wall'
alias g++='g++ -std=c++1z -Wall'
alias screen='screen -U'
# alias scons='python3 $(which scons)'

function scons()
{
    python3 $(which scons) $@
}


function stop_docker()
{
    if [ $# -gt 0 ]
    then
        containers=$(docker ps -a | grep $1 | cut -d' ' -f1)
    else
        containers=$(docker ps -a | awk "NR > 1" | cut -d' ' -f1)
    fi
    echo ${containers}
    if [ "${containers}x" != "x" ]
    then
        echo ${containers} | xargs docker stop
    fi
}

function rm_docker()
{
    if [ $# -gt 0 ]
    then
        containers=$(docker ps -a | grep $1 | grep "Exited.*ago" | cut -d' ' -f1)
    else
        containers=$(docker ps -a | grep "Exited.*ago" | cut -d' ' -f1)
    fi
    echo ${containers}
    if [ "${containers}x" != "x" ]
    then
        echo ${containers} | xargs docker rm
    fi
}

function clean_dockeri()
{
    case $# in
    0)
        images=$(docker images | grep "<none>" | awk '{print $3}')
        if [ "${images}x" == "x" ]
        then
            echo "nothing to do"
            return 0
        fi
        docker rmi ${images}
        ;;
    *)
        # shift
        for arg in $*
        do
            docker rmi $(docker images|grep ${arg}|awk '{printf "%s:%s\n", $1,$2}')
        done
        ;;
    esac
}

function cd()
{
    builtin cd $@ && ls
}

function re_link_gcc()
{
    if [ $# -lt 1 ]
    then
	echo usage:re_link_gcc version. eg: re_link_gcc 9
	return 1
    fi
    sudo rm /usr/bin/gcc
    sudo rm /usr/bin/g++
    sudo ln -s /usr/bin/gcc-$1 /usr/bin/gcc
    sudo ln -s /usr/bin/g++-$1 /usr/bin/g++
}



ulimit -c unlimited

# devtoolset-7
if [ $MKOSTYPE = "centos" ]
then
    #export PATH=/opt/rh/devtoolset-7/root/bin:$PATH
    #export PATH=/opt/rh/rh-python36/root/bin:$PATH
    source /opt/rh/devtoolset-8/enable
    # source /opt/rh/rh-python36/enable
    source /opt/rh/rh-mysql80/enable
    # scl enable devtoolset-7 bash
fi

#if [ 4 -eq $SHLVL ] && [ $MKOSTYPE = "centos" ]
#then
#    scl enable rh-${PYTHON} bash
#fi

which ccache &> /dev/null
if [ 0 -eq $? ]
then
    export CCACHE_DIR=/tmp/${USER}/ccache
    ccache --max-size=10G > /dev/null
    export CCACHE_SIZE=10G # redundant; set anyway
    export CCACHE_UMASK=0 # shared to world
fi
export PKG_CONFIG_PATH=${HOME}/usr/lib/pkgconfig

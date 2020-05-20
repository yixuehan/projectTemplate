#!/bin/bash

repo=$(realpath $(dirname ${BASH_SOURCE})/..)

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

libs_dir=~/usr
libs=(boost mysql nlohmann_json jsoncpp FFmpeg spdlog json grpc aliyun-oss-cpp-sdk rapidjson cmake openssl sqlite3 vim \
      hiredis-v opencv ccache muduo cryptopp libev zip ftplibpp protobuf mqtt_c mqtt_cpp mosquitto sqlite_modern_cpp)
for lib in ${libs[@]}
do
#    echo ${lib}
    include_path=${include_path}:${libs_dir}/${lib}/include
    if [ -d ${libs_dir}/${lib}/lib ]
    then
        lib_path=${lib_path}:${libs_dir}/${lib}/lib
    elif [ -d ${libs_dir}/${lib}/lib64 ]
    then
        lib_path=${lib_path}:${libs_dir}/${lib}/lib64
    fi
    bin_path=${bin_path}:${libs_dir}/${lib}/bin
done

export PAHO_MQTT_C_LIBRARIES=${libs_dir}/mqtt_c/include
export PAHO_MQTT_C_INCLUDE_DIRS=${libs_dir}/mqtt_c/lib

#echo $include_path
#echo $lib_path
#echo $bin_path

export C_INCLUDE_PATH=${include_path}/${C_INCLUDE_PATH}
export C_INCLUDE_PATH=${C_INCLUDE_PATH}:~/projectTemplate/util/cpp

export CPLUS_INCLUDE_PATH=${C_INCLUDE_PATH}:${CPLUS_INCLUDE_PATH}


export LD_LIBRARY_PATH=${lib_path}:${LD_LIBRARY_PATH}
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${OPENCL_LIBRARY_PATH}

export LIBRARY_PATH=$LD_LIBRARY_PATH:${LIBRARY_PATH}

export PATH=${bin_path}:${PATH}

export PS1='[\u@\h \W]\$ '

export MKHOME=${repo}/mak
# export PYTHONPATH=$PYTHONPATH:${HOME}/usr/lib/python3.6/site-packages:${HOME}/gencode
export PYTHONPATH=$PYTHONPATH:${HOME}/usr/lib/python3.6/site-packages
# export PYTHONPATH=$PYTHONPATH:${HOME}/gencode

export LOGICAL_NUM=`cat /proc/cpuinfo | grep "processor" | wc -l`
export PHYSICAL_NUM=`cat /proc/cpuinfo | grep "physical id" | uniq | wc -l`

export PKG_CONFIG_PATH=${HOME}/usr/lib/pkgconfig

#export MANPATH=/home/wangkai/project/thirdLib/${MKOSTYPE}/google_coredumper/man

alias cds='cd $PRONAME/src'
alias cdi='cd $PRONAME/include'
alias cdm='cd ${repo}/mak'
alias cdsh='cd ${repo}/sh'
alias cdl='cd $PRONAME/log'
alias cdb='cd $PRONAME/bin'
alias cdp='cd $PRONAME'
alias cdlib='cd $PRONAME/lib'
alias cpmake='cp ${repo}/mak/build.sh . && chmod +x build.sh'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
# alias docker++='docker run --rm -v${PWD}:/workdir -w/workdir w505703394/centos:dev g++ -std=c++2a -Wall'
alias docker++='docker run --rm -v${PWD}:/workdir -w/workdir gcc g++ -std=c++2a -Wall'
alias g++='ccache g++ -std=c++1z -Wall'
alias screen='screen -U'
# alias scons='python3 $(which scons)'

function scons()
{
    python3 $(which scons) $@
}

function lnboost()
{
    unlink ~/usr/boost || true
    ln -s boost_$1 ~/usr/boost
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
    # echo $*
    # echo $@
    if [ "allx" == "${1}x" ]
    then
        containers=$(docker ps -a | grep "Exited.*ago" | cut -d' ' -f1)
    # elif [ $# -eq 0 ]
    # then
    #     containers=$(docker ps -a | grep $1 | grep "Exited.*ago" | cut -d' ' -f1)
    else
        containers=$@
    fi
    # echo ${containers}
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

function compile_num()
{
    MemAvailable=$(cat /proc/meminfo | grep MemAvailable | tr -cd "[0-9]")
    MemAvailable=$(expr ${MemAvailable} / 800 / 1024)
    NUM=${LOGICAL_NUM}
    if [ ${MemAvailable} -le 0 ] 
    then
        NUM=1
    elif [ ${NUM} -ge ${MemAvailable} ]
    then
        NUM=${MemAvailable}
    fi
    echo ${NUM}
    # return ${NUM}
}

function build()
{
    old=$(pwd)
    mkdir build
    cd build
    cmake ..
    NUM=`compile_num`
	echo "make -j${NUM} VERBOSE=1"
    make -j${NUM} VERBOSE=1
    cd ${old}
}

function cd()
{
    builtin cd "$@" && ls
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
if [ "$MKOSTYPE" = "centos" ]
then
    grep "release 8" /etc/centos-release &>/dev/null
    if [ ! $? -eq 0 ]
    then
        #export PATH=/opt/rh/devtoolset-7/root/bin:$PATH
        #export PATH=/opt/rh/rh-python36/root/bin:$PATH
        source /opt/rh/devtoolset-8/enable
        # source /opt/rh/rh-python36/enable
        # source /opt/rh/rh-mysql80/enable
        # scl enable devtoolset-7 bash
    fi
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

function clean_git_history()
{
    git checkout --orphan latest_branch
    git add -A
    git commit -am "清除所有历史版本"
    git branch -D master
    git branch -m master
    git push -f origin master
}

function docker_search()
{
    for Repo in $* ; do
      curl -s -S "https://registry.hub.docker.com/v2/repositories/library/$Repo/tags/" | \
        sed -e 's/,/,\n/g' -e 's/\[/\[\n/g' | \
        grep '"name"' | \
        awk -F\" '{print $4;}' | \
        sort -fu | \
        sed -e "s/^/${Repo}:/"
    done
}

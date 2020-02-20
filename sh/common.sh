#!/bin/bash

if [ ${NUM_CPU}x == "x" ]
then
    NUM_CPU=2
fi

exec_echo()
{
    echo $@
    $@
}

shelldir=$(dirname $0)
gitdir=$(realpath ${shelldir}/../git_tmp)

# git_pull repo [branch]
git_pull()
{
    old_path=$(pwd)
    if [ ! -d ${gitdir} ]
    then
        exec_echo mkdir ${gitdir}
    fi

    repo=$1
    exec_echo cd $gitdir
    repodir=$(basename $1 | cut -d'.' -f1)

    if [ $# -gt 1 ]
    then
        branch="-b $2"
    fi

    if [ ! -d $repodir ]
    then
        exec_echo git clone ${branch} $repo --depth=1
        cd ${repodir}
        exec_echo git submodule update --init --recursive --depth=1
    fi
    cd ${old_path}
    return 
}

download()
{
    old_path=$(pwd)
    download_path=$1
    cd ${download_path}
    url=$2
    if [ $# -eq 3 ]
    then
        target=$3
    else
        target=$(basename ${url})
    fi

    if [ ! -f ${target} ]
    then
        wget ${url} -O${target}
        ret=$?
        if [ ${ret} -eq 0 ]
        then
            unzip ${target}
        else
            exit ${ret}
        fi
    fi
    cd ${old_path}
}

cmake_install()
{
    # src_dir _install_dir
    if [ $# -lt 2 ]
    then
        echo "cmake_install src_dir _install_dir"
        return 1
    fi
    echo ".$0#." ".#$1." ".$2."
    src_dir=$1
    _install_dir=$2
    cmake_flags=""
    if [ $# -eq 3 ]
    then
        cmake_flags=$3
    fi

    cd ${src_dir}
    rm -rf build
    mkdir build
    cd build
    cmake -DCMAKE_INSTALL_PREFIX=${_install_dir} $cmake_flags ..
    make -j${NUM_CPU} install
}

configure_install()
{
    # src_dir _install_dir
    if [ $# -lt 2 ]
    then
        echo "configure_install src_dir _install_dir"
        return 1
    fi
    src_dir=$1
    _install_dir=$2
    configure_flags=""
    if [ $# -eq 3 ]
    then
        configure_flags=$3
    fi
    cd ${src_dir}
    ./configure --prefix=${_install_dir} $configure_flags
    make -j${NUM_CPU} install
}

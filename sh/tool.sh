#!/bin/bash
exec()
{
    echo ${1}
    $1
}
update_module()
{
    old_path=$(pwd)
    tag=$1
    repo=$2
    dir=$3
    git_path=$4
    depth=" --depth=1"
    if [ ! -d $git_path ]
    then
        echo mkdir $git_path
        mkdir $git_path
    fi
    cd $git_path

    if [ -d $dir ]
    then
        cd ${dir}
        # exec "git pull"
        exec "git submodule update --init --recursive"
    else
        exec "git clone -b ${tag} ${repo} ${dir}"
        cd ${dir}
        exec "git submodule update --init --recursive"
    fi
    # git clone -b v1.23.0 https://github.com/grpc/grpc.git grpc
    cd ${old_path}
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

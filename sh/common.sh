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

getrepo()
{
    echo $0
    echo $1
    return "$(basename $0 | cut -d'.' -f1)"
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

    if [ -d $repodir ]
    then
        cd ${repodir}
        exec_echo git pull
    else
        exec_echo git clone ${branch} $repo --depth=1
        cd ${repodir}
    fi
    exec_echo git submodule update --init --recursive
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

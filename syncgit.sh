#!/bin/bash
SUDO='sudo -H'

update_module()
{
    old_path=$(pwd)
    repo=$1
    dir=$2
    download_path=$3
    if [ ! -d $download_path ]
    then
        echo mkdir $download_path
        mkdir $download_path
    fi

    echo "update_module $repo $dir"
    cd $download_path
    if [ -d $dir ]
    then
        rm -rf $dir
        git clone $repo $dir --depth=1
        cd $dir
        git submodule update --init --recursive --depth=1
    fi

    cd ${old_path}
}

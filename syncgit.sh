#!/bin/bash
SUDO='sudo -H'

update_module()
{
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
        cd $dir
        #${SUDO} chown -R ${USER}.${USER} .
        # git checkout master
        git pull --depth 1
        git submodule update --init --recursive
        # rm -rf $dir
    else
        git clone $repo $dir --depth 1
        cd $dir
        git submodule update --init --recursive
    fi


    cd ${download_path}/${dir}
}

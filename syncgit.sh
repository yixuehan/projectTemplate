#!/bin/bash
update_module()
{
    old_path=$(pwd)
    repo=$1
    dir=$2
    download_path=$3
    depth=" --depth=1"
    if [ ! -d $download_path ]
    then
        echo mkdir $download_path
        mkdir $download_path
    fi
    cd $download_path
    echo "update_module $repo $dir"

    # if [[ ${repo} =~ "grpc" ]] && [ -d ${dir} ]
    # then
	# depth=""
    # fi

    #if [[ ${repo} =~ "grpc" ]] && [ -d ${dir} ]
    #then
	#git pull
    #else
    if [ -d $dir ]
    then
        rm -rf $dir
    fi
    git clone $repo $dir ${depth}
    cd $dir

    git submodule update --init --recursive ${depth}

    cd ${old_path}
}

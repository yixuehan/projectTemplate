#!/bin/bash

if [ ${PHYSICAL_NUM}x == "x" ]
then
    PHYSICAL_NUM=2
fi

exec_echo()
{
    echo $@
    $@
}

shelldir=$(dirname $0)
git_dir=$(realpath ${shelldir}/../git_tmp)
download_dir=$(realpath ${shelldir}/../download_tmp)

# git_tmp_pull repo [branch]
git_tmp_pull()
{
    old_path=$(pwd)
    if [ ! -d ${git_dir} ]
    then
        exec_echo mkdir ${git_dir}
    fi

    exec_echo cd $git_dir
    git_pull $*
    cd ${old_path}

}

# git_sync_pull repo [branch]
git_sync_pull()
{
    old_path=$(pwd)
    repo=$1
    repodir=$(basename $1)
    repodir=${repodir::-4}

    if [ $# -gt 1 ]
    then
        branch="-b $2"
    fi

    if [ ! -d $repodir ]
    then
        exec_echo git clone ${branch} $repo --depth=1
        cd ${repodir}
        exec_echo git submodule sync --recursive
        exec_echo git submodule update --init --recursive
    fi
    cd ${old_path}
}

# git_pull repo [branch]
git_pull()
{
    old_path=$(pwd)
    repo=$1
    repodir=$(basename $1)
    repodir=${repodir::-4}

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
}

# git_commit_pull commit
# 有些github最新的提交可能有bug无法编译，取其中某次提交
# 只拉取最新的10次提交
git_commit_pull()
{
    old_path=$(pwd)
    repo=$1
    repodir=$(basename $1)
    repodir=${repodir::-4}

    if [ $# -gt 1 ]
    then
        commit="-b $2"
    fi

    if [ ! -d $repodir ]
    then
        exec_echo git clone $repo --depth=50
        cd ${repodir}
        exec_echo git checkout ${commit}
        exec_echo git submodule update --init --recursive --depth=1
    fi
    cd ${old_path}
}

# src_dir install_dir _cmake_flags
cmake_install()
{
    # src_dir _install_dir
    if [ $# -lt 2 ]
    then
        echo "cmake_install src_dir _install_dir"
        return 1
    fi
    #echo ".$0#." ".#$1." ".$2."
    _src_dir=$1
    _install_dir=$2
    _cmake_flags=""
    if [ $# -eq 3 ]
    then
        _cmake_flags=$3
    fi

    cd ${_src_dir}
    rm -rf build
    mkdir build
    cd build
    cmake -DCMAKE_INSTALL_PREFIX=${_install_dir} $_cmake_flags ..
    make -j${PHYSICAL_NUM} install
}

# src_dir install_dir qmake_flags
qmake_install()
{
    # src_dir _install_dir
    if [ $# -lt 2 ]
    then
        echo "qmake_install src_dir _install_dir"
        return 1
    fi
    echo ".$0#." ".#$1." ".$2."
    _src_dir=$1
    _install_dir=$2
    _qmake_flags=""
    if [ $# -eq 3 ]
    then
        _qmake_flags=$3
    fi

    cd ${_src_dir}
    rm -rf build
    mkdir build
    cd build
    # qmake PREFIX=${_install_dir} $_qmake_flags ..
    /usr/lib/aarch64-linux-gnu/qt5/bin/qmake PREFIX=${_install_dir} $_qmake_flags ..
    make -j${PHYSICAL_NUM} install
}

# src_dir install_dir configure_flags
configure_install()
{
    # src_dir _install_dir
    if [ $# -lt 2 ]
    then
        echo "configure_install src_dir _install_dir"
        return 1
    fi
    _src_dir=$1
    _install_dir=$2
    configure_flags=""
    if [ $# -eq 3 ]
    then
        configure_flags=$3
    fi
    cd ${_src_dir}
    _config=configure
    if [[ ${_src_dir} =~ "openssl" ]]
    then
        _config=config
    fi
    ./${_config} --prefix=${_install_dir} $configure_flags
    make -j${PHYSICAL_NUM} install
}

# url [dirname]
# 有些压缩包解压后的名字可能不一样，需要手动指定
download() 
{
    if [ $# -lt 1 ]
    then
        echo usage:download_zip url [dirname] 
    fi
    cd ${download_dir}
    url=$1
    _filename=$(basename ${url})

    if [ ! -f ${_filename} ]
    then
        wget ${url}
        if [ ! $? -eq 0 ]
        then
            rm -rf ${_filename}
            return 1
        fi
    fi


    _suffixs=(.tar.gz .zip tar.bz2)
    _suffix=
    for x in ${_suffixs}
    do
        echo ${x}
        if [[ ${_filename} =~ ${x} ]]
        then
            _suffix=${x}
            break
        fi
    done
    
    echo ${_filename} ${_suffix} ${#_suffix}
    _dirname=${_filename::-${#_suffix}}
    if [ $# -eq 2 ]
    then
        _dirname=$2
    fi

    if [ ! -d ${_dirname} ]
    then
        case ${_suffix} in
        .tar.gz)
            tar -xf ${_filename}
            ;;
        .zip)
            tar -zxf ${_filename}
            ;;
        .tar.bz2)
            tar -jxf ${_filename}
            ;;
        *)
            echo unknown file format ${_filename}
            return 1
            ;;
        esac
    fi
    return 0
}

#!/bin/bash

if [ ${PRONAME}x == ""x ]
then
    echo 请先设置[PRONAME]
    exit 1
fi

sudo apt install cmake ccache -y

#设置mak、shell路径`
download_path=${HOME}/git_download
shellpath=$PWD

if [ ! -d $download_path ]
then
    echo mkdir $download_path
    mkdir $download_path
fi

mkdir -p ${PRONAME}/bin ${PRONAME}/log ${PRONAME}/lib ${PRONAME}/include ${PRONAME}/src ${PRONAME}/etc

pull()
{
   #git submodule add https://github.com/yixuehan/makeTemplate.git
   #git submodule add https://github.com/boostorg/boost.git
   #git submodule add https://github.com/grpc/grpc.git
   #cd ${shellpath}
   #git pull
   #git pull --recurse-submodules
   null
}

update_module()
{
    echo "update_module $1 $2"
    cd $download_path
    if [ -d $1 ]
    then
        cd $1
        git pull
        git submodule update --init --recursive
    else
        git clone $2 $1
        cd $1
        git submodule update --init --recursive
    fi
}

# 编译boost
boost()
{
    echo 编译boost...
    cd $shellpath/boost
    ./bootstrap.sh --libdir=${HOME}/usr/lib --includedir=${HOME}/usr/include
    ./bjam cxxflags="-std=c++1z" variant=release install
}

# 编译grpc
grpc()
{
    update_module grpc https://github.com/grpc/grpc.git
    echo 编译grpc...
    sudo apt-get install build-essential autoconf libtool pkg-config -y
    sudo apt-get install libgflags-dev libgtest-dev -y
    sudo apt-get install clang libc++-dev -y
    make && make install prefix=${HOME}/usr
    cd $shellpath/grpc/third_party/protobuf
    make && make install prefix=${HOME}/usr
}

# 编译json
json()
{
    echo 编译json...
    update_module json https://github.com/nlohmann/json.git
    cd $shellpath/json
    rm -rf build
    mkdir build
    cd build
    cmake -DCMAKE_INSTALL_PREFIX=${HOME}/usr ..
    make install
}

demjson()
{
    update_module demjson https://github.com/dmeranda/demjson.git
    cd demjson
    python3 setup.py install --prefix ${HOME}/usr
}

echo $*
for library in $* ; do
    echo $library
    eval "${library}"
done

#提示
echo 在.bashrc中增加:
echo 'export MKHOME=${HOME}/projectTemplate/mak'
echo '. ${HOME}/projectTemplate/env/env.sh'
echo 'export PYTHONPATH=$PYTHONPATH:${HOME}/usr/lib/python3.6/site-packages'

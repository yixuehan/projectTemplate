#!/bin/bash

if [ ${PRONAME}x == ""x ]
then
    echo 请先设置[PRONAME]
    exit 1
fi

if [ -e '/etc/centos-release' ]
then
    MKOSTYPE=centos
else
    MKOSTYPE=$(echo `lsb_release -a 2>/dev/null |grep -i distributor| tr A-Z a-z|cut -d':' -f2`)
fi

case $MKOSTYPE in
    ubuntu) sudo apt install cmake ccache -y;;
    centos) sudo yum install devtoolset-7 -y
            which ccache 1>/dev/null
            if [ $? != 0 ]
            then
                echo 手动安装ccache
            fi
            which cmake 1>/dev/null
            if [ $? != 0 ]
            then
                echo 手动安装cmake
            fi
            ;;
            
esac

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
    update_module boost https://github.com/boostorg/boost.git
    ./bootstrap.sh --libdir=${HOME}/usr/lib --includedir=${HOME}/usr/include
    ./bjam cxxflags="-std=c++1z" variant=release install
}

# 编译grpc
grpc()
{
    update_module grpc https://github.com/grpc/grpc.git
    echo 编译grpc...
    case $MKOSTYPE in
        ubuntu) sudo apt-get install build-essential autoconf libtool pkg-config -y
                sudo apt-get install libgflags-dev libgtest-dev -y
                sudo apt-get install clang libc++-dev -y;;
        centos) sudo yum install build-essential autoconf libtool pkg-config -y
                sudo yum install libgflags-dev libgtest-dev -y
                sudo yum install libc++-dev -y;;
    esac
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
echo '. ${HOME}/projectTemplate/env/env.sh'

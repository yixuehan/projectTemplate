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

software()
{
    which $1 1>/dev/null
    if [ $? != 0 ]
    then
    	. ${1}.sh
    	which $1 1>/dev/null
    	if [ $? != 0 ]
	    then
            echo 手动安装$1
	        exit 1
        fi
    fi
}

case $MKOSTYPE in
    ubuntu) sudo apt install cmake ccache -y
            sudo apt install git -y
            sudo apt install wget -y
            ;;
    centos) sudo yum install centos-release-scl -y
            sudo yum install devtoolset-7 -y
            sudo yum install rh-python36
            sudo yum install git -y
            #提示
            if [ 2 -eq $SHLVL ]
            then
                echo 在.bashrc中增加:
                echo '. ${HOME}/projectTemplate/env/env.sh'
                exit 1
            fi
            sudo yum install wget
            software cmake
            software ccache
            ;;
esac

git config --global credential.helper store

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
    git checkout master
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
    rm -rf build
    mkdir build
    cd build
    cmake -DCMAKE_INSTALL_PREFIX=${HOME}/usr ..
    make install
}

scons()
{
    update_module scons https://github.com/SCons/scons.git
    export setenv MYSCONS=`pwd`/src
    python $MYSCONS/script/scons.py
    python bootstrap.py build/scons
    cd build/scons
    python setup.py install --prefix=${HOME}/usr
}

gtest()
{
    update_module googletest https://github.com/google/googletest.git
}

demjson()
{
    update_module demjson https://github.com/dmeranda/demjson.git
    python3 setup.py install --prefix ${HOME}/usr
}

vimdev()
{
    sudo apt install build-essential cmake python3-dev
    sudo apt install ctags
    sudo apt install golang
    go get -u github.com/jstemmer/gotags
    if [ ! -d ~/.vim/bundle/Vundle.vim ]
    then
        git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    fi
    if [ ! -f ~/.vimrc ]
    then
        ln -s ${PWD}/vimrc ~/.vimrc
    else
        mv ~/.vimrc ~/.vimrc.bak
        ln -s ${PWD}/vimrc ~/.vimrc

	    mv ~/.go.vimrc ~/.go.vimrc.bak
        ln -s ${PWD}/go.vimrc ~/.go.vimrc

	    mv ~/.cpp.vimrc ~/.cpp.vimrc.bak
        ln -s ${PWD}/cpp.vimrc ~/.cpp.vimrc

        mv ~/.bundle.vimrc ~/.bundle.vimrc.bak
        ln -s ${PWD}/bundle.vimrc ~/.bundle.vimrc
    fi
    vim +PluginInstall! +qall
    vim +GoInstallBinaries! +qall
    #vim -u $HOME/.bundle.vimrc +PluginInstall! +qall
    #vim -u $HOME/.bundle.vimrc +GoInstallBinaries! +qall

    cd ~/.vim/bundle/YouCompleteMe
    git submodule update --init --recursive
    python3 install.py --clang-completer --go-completer 
    if [ ! -f ~/.ycm_extra_conf.py ]
    then
        cp ${HOME}/.vim/bundle/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py ~/.ycm_extra_conf.py
    fi
}

echo $*
for library in $* ; do
    echo $library
    eval "${library}"
done


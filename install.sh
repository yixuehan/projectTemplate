#!/bin/bash

#if [ ${PRONAME}x == ""x ]
#then
#    echo 请先设置[PRONAME]
#    exit 1
#fi

if [ -e '/etc/centos-release' ]
then
    MKOSTYPE=centos
else
    MKOSTYPE=$(echo `lsb_release -a 2>/dev/null |grep -i distributor| tr A-Z a-z|cut -d':' -f2`)
fi

software()
{
    which $1 &>/dev/null
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
    ubuntu) sudo apt install cmake ccache git wget vim docker.io python3-dev cmake build-essential ctags golang g++ -y
            #sudo apt install vim-nox vim-gnome vim-athena vim-gtk -y
            ;;
    centos) sudo yum install -y centos-release-scl 
            sudo yum install -y devtoolset-7
            sudo yum install -y epel-release
            sudo yum update -y
            sudo yum install -y make mysql-devel wget which ccache
            sudo yum install rh-python36 rh-python36-python-devel -y
            sudo yum install git vim bzip2 -y
            which docker 2>/dev/null
            if [ $? != 0 ]
            then
                sudo curl -fsSL https://get.docker.com/ | sh
            	sudo systemctl enable docker
            	sudo systemctl start docker
            fi
            sudo yum clean all
            #提示
            source ${PWD}/env/env.sh
            sudo yum install wget
            software cmake
            #software ccache
            ;;
esac

git config --global credential.helper store

sudo pip3 install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple
sudo pip3 install GitPython requests scons lxml mako numpy wget -i https://pypi.tuna.tsinghua.edu.cn/simple

PYTHON=`which python3`

#设置mak、shell路径`
download_path=${HOME}/.git_download

if [ ! -d $download_path ]
then
    echo mkdir $download_path
    mkdir $download_path
fi

update_module()
{
    echo "update_module $1 $2"
    cd $download_path
    if [ -d $1 ]
    then
        cd $1
        sudo chown -R ${USER}.${USER} .
        git checkout master
        git pull
        git submodule update --init --recursive

    else
        git clone $2 $1
        cd $1
        git submodule update --init --recursive
    fi
    cd ${download_path}/${1}
}

# 编译boost
boost()
{
    echo 编译boost...
    ${PYTHON} boost.py
}

# 编译grpc
grpc()
{
    update_module grpc https://github.com/grpc/grpc.git
    echo 编译grpc...
    case $MKOSTYPE in
        ubuntu) sudo apt install build-essential autoconf libtool pkg-config libgflags-dev libgtest-dev clang libc++-dev -y;;
        centos) sudo yum install build-essential autoconf libtool pkg-config -y
                sudo yum install libgflags-dev libgtest-dev -y
                sudo yum install libc++-dev -y;;
    esac
    make && make install prefix=${HOME}/usr
    cd $download_path/grpc/third_party/protobuf
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
    #oldpath=${PWD}
    #update_module scons https://github.com/SCons/scons.git
    #${oldpath}/scons.sh
}

gtest()
{
    update_module googletest https://github.com/google/googletest.git
}

demjson()
{
    update_module demjson https://github.com/dmeranda/demjson.git
    ${PYTHON} setup.py install --prefix ${HOME}/usr
}

vimdev()
{
    go get -u github.com/jstemmer/gotags
    if [ ! -d ~/.vim/bundle/Vundle.vim ]
    then
        git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    fi
    if [ -f ~/.vimrc ]
    then 
        mv ~/.vimrc ~/.vimrc.bak
    fi
    ln -s ${PWD}/cpp.vimrc ~/.vimrc -f

    vim -u ${PWD}/cpp.vimrc +PluginInstall! +qall
    vim -u ${PWD}/go.vimrc +GoInstallBinaries! +qall
    #vim -u $HOME/.bundle.vimrc +PluginInstall! +qall
    #vim -u $HOME/.bundle.vimrc +GoInstallBinaries! +qall

    cd ~/.vim/bundle/YouCompleteMe
    git submodule update --init --recursive
    ${PYTHON} install.py --clang-completer --go-completer
    #${PYTHON} install.py --clang-completer
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

echo 在.bashrc中增加:
echo ". ${PWD}/env/env.sh"

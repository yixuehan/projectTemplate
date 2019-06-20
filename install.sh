#!/bin/bash

#if [ ${PRONAME}x == ""x ]
#then
#    echo 请先设置[PRONAME]
#    exit 1
#fi

source syncgit.sh

SUDO='sudo -H'
if [ -e '/etc/centos-release' ]
then
    MKOSTYPE=centos
else
    MKOSTYPE=$(echo `lsb_release -a 2>/dev/null |grep -i distributor| tr A-Z a-z|cut -d':' -f2`)
fi

shellpath=${PWD}

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
    ubuntu) ${SUDO} apt install cmake ccache git wget vim docker.io python3-dev cmake build-essential ctags golang g++ libssl-dev python3-pip -y
            #${SUDO} apt install vim-nox vim-gnome vim-athena vim-gtk -y
            ;;
    centos) ${SUDO} yum install -y centos-release-scl 
            ${SUDO} yum install -y devtoolset-7
            ${SUDO} yum install -y epel-release
            ${SUDO} yum update -y
            ${SUDO} yum install -y make mysql-devel wget which ccache autoconf \
            rh-python36 rh-python36-python-devel git vim bzip2 openssl-devel ncurses-devel

            which docker 2>/dev/null
            if [ $? != 0 ]
            then
                ${SUDO} curl -fsSL https://get.docker.com/ | sh
            	${SUDO} systemctl enable docker
            	${SUDO} systemctl start docker
		${SUDO} usermod -a -G docker ${USER}
            fi

            # ${SUDO} yum clean all
            #提示
            source ${PWD}/env/env.sh
            ${SUDO} yum install wget
            software cmake
            #software ccache
            ;;
esac

git config --global credential.helper store

${SUDO} pip3 install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple
${SUDO} pip3 install -U GitPython apio requests scons lxml mako numpy wget sqlparser pandas flake8 jaydebeapi -i https://pypi.tuna.tsinghua.edu.cn/simple

PYTHON=`which python3`

#设置mak、shell路径`
download_path=${shellpath}/.git_download

if [ ! -d $download_path ]
then
    echo mkdir $download_path
    mkdir $download_path
fi

# update_module()
# {
#     repo=$1
#     dir=$2
#     echo "update_module $repo $dir"
#     cd $download_path
#     if [ -d $dir ]
#     then
#         cd $dir
#         ${SUDO} chown -R ${USER}.${USER} .
#         # git checkout master
#         git pull
#         git submodule update --init --recursive --depth 1
# 
#     else
#         git clone $repo $dir --depth 1
#         cd $dir
#         git submodule update --init --recursive --depth 1
#     fi
#     cd ${download_path}/${dir}
# }

# 编译boost
boost()
{
    echo 编译boost...
    # update_module https://github.com/boostorg/boost.git boost
    ${PYTHON} boost.py
}

# 编译grpc
grpc()
{
    # update_module https://github.com/grpc/grpc.git grpc ${download_path}
    cd ${download_path}
    version=1.21.4
    if [ ! -f v${version}.zip ]
    then
        wget https://github.com/grpc/grpc/archive/v${version}.zip
        if [ ! 0 -eq $? ]
        then
            rm -rf v${version}.zip
            exit 1
        fi
        unzip v${version}.zip
    fi
    cd grpc-${version}
    echo 编译grpc...
    case $MKOSTYPE in
        ubuntu) ${SUDO} apt install -y build-essential autoconf libtool pkg-config libgflags-dev libgtest-dev clang libc++-dev ;;
        centos) ${SUDO} yum install -y build-essential autoconf libtool pkg-config \
                libgflags-dev libgtest-dev libc++-dev ;;
    esac
    make && make install prefix=${HOME}/usr
    cd $download_path/grpc/third_party/protobuf
    make && make install prefix=${HOME}/usr
}

# 编译json
json()
{
    echo 编译json...
    update_module https://github.com/nlohmann/json.git json ${download_path}
    rm -rf build
    mkdir build
    cd build
    cmake -DCMAKE_INSTALL_PREFIX=${HOME}/usr ..
    make install
}

gtest()
{
    update_module https://github.com/google/googletest.git googletest ${download_path}
    rm -rf build
    mkdir build
    cd build
    cmake ..
    make
    cp lib/* ${HOME}/usr/lib
    cp -R ../googletest/include/gtest ${HOME}/usr/include
}

demjson()
{
    update_module https://github.com/dmeranda/demjson.git demjson ${download_path}
    ${PYTHON} setup.py install --prefix ${HOME}/usr
}

updatevim()
{
	rm -rf vim-master master.zip
	wget https://github.com/vim/vim/archive/master.zip
	unzip master.zip
	cd vim-master
	cd src/
	./configure --with-features=huge \
    --enable-pythoninterp \
    --enable-python3interp
    make
	${SUDO} make install
    if [ $? != 0 ]
    then
        exit $?
    fi
	hash -r
}

vimdev()
{
    cd ${shellpath}
    go get -u github.com/jstemmer/gotags
    if [ ! -d ~/.vim/bundle/Vundle.vim ]
    then
        git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim --depth 1
    fi
    if [ -f ~/.vimrc ]
    then 
        mv ~/.vimrc ~/.vimrc.bak
    fi
    ln -s ${PWD}/cpp.vimrc ~/.vimrc -f

    vim -u ${PWD}/cpp.vimrc +PluginInstall! +GoInstallBinaries +qall
    # vim -u ${PWD}/go.vimrc +GoInstallBinaries! +qall

    cd ~/.vim/bundle/YouCompleteMe
    git submodule update --init --recursive
    # ${PYTHON} install.py --clang-completer --go-completer
    ${PYTHON} install.py --clang-completer
    if [ ! -f ~/.ycm_extra_conf.py ]
    then
        cp ${HOME}/.vim/bundle/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py ~/.ycm_extra_conf.py
    fi
}

echo $*
for library in $* ; do
    echo $library
    cd ${shellpath}
    eval "${library}"
done

echo 在.bashrc中增加:
echo ". ${shellpath}/env/env.sh"

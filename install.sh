#!/bin/bash

#if [ ${PRONAME}x == ""x ]
#then
#    echo 请先设置[PRONAME]
#    exit 1
#fi

source sync_git.sh

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
	ubuntu)
            SUDO="sudo -H"
    	    RHSUDO=${SUDO}
    	    PIP3=pip3
	    PYTHON=python3
	    ;;
        centos) 
    	    SUDO="/bin/sudo -H"
    	    PIP3=$(which pip3)
    	    RHSUDO="sudo"
            PYTHON=python36
	    ;;
	*)
	    echo unknown os type [$MKOSTYPE]
	    exit 1
	    ;;
esac


software cmake

env_install()
{
    case $MKOSTYPE in
        ubuntu) 
            ${SUDO} apt update && ${SUDO} apt upgrade -y
    	    ${SUDO} apt install -y ccache git wget vim docker.io python3-dev build-essential ctags golang g++ libssl-dev python3-pip \
                                   python3-tk
    
                #${SUDO} apt install vim-nox vim-gnome vim-athena vim-gtk -y
            bash go.sh
                ;;
        centos) 
    	    ${SUDO} yum install -y centos-release-scl 
                ${SUDO} yum install -y devtoolset-8
                ${SUDO} yum install -y epel-release
                ${SUDO} yum update -y
                ${SUDO} yum install -y make mysql-devel wget which ccache autoconf \
                ${PYTHON} ${PYTHON}-pip ${PYTHON}-devel ${PYTHON}-tkinter \
                git bzip2 openssl-devel ncurses-devel \
                # golang
                which go 2>/dev/null
                if [ $? != 0 ]
                then
                    bash go.sh
                fi
                # which docker 2>/dev/null
                # if [ $? != 0 ]
                # then
                    ${SUDO} curl -fsSL https://get.docker.com/ | bash
                	${SUDO} systemctl enable docker
                	${SUDO} systemctl start docker
    		        ${SUDO} usermod -a -G docker ${USER}
                # fi
    
                # ${SUDO} yum clean all
                #提示
                source ${PWD}/env/env.sh
                ${SUDO} yum install wget
                ;;
    esac
    
    git config --global credential.helper store
    
    echo ${SUDO}
    
    ${SUDO} ${PIP3} install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple
    ${SUDO} ${PIP3} install -U openpyxl \
                GitPython apio requests scons lxml mako numpy wget sqlparser pandas flake8 jaydebeapi jupyter \
		docker-compose  \
    		-i https://pypi.tuna.tsinghua.edu.cn/simple

}



#设置mak、shell路径`
git_path=${shellpath}/.git_download
download_path=${shellpath}/download_tmp

if [ ! -d $git_path ]
then
    echo mkdir $git_path
    mkdir $git_path
fi

# 编译boost
boost()
{
    echo 编译boost...
    ./boost.py
}

# 编译grpc
grpc()
{
    old_path=$(pwd)
    update_module v1.23.0 https://github.com/grpc/grpc.git grpc ${git_path}

    echo 编译grpc...
    case $MKOSTYPE in
        ubuntu) ${SUDO} apt install -y build-essential autoconf libtool pkg-config libgflags-dev libgtest-dev clang libc++-dev ;;
        centos) ${SUDO} yum install -y build-essential autoconf libtool pkg-config \
                libgflags-dev libgtest-dev libc++-dev ;;
    esac
    cd ${git_path}/grpc/third_party/protobuf
    ./autogen.sh
    ./configure --prefix=${HOME}/usr
    make && make install
    cd ${git_path}/grpc
    make && make install prefix=${HOME}/usr
    cd ${old_path}
}

# 编译json
json()
{
    echo 编译json...
    update_module v3.7.0 https://github.com/nlohmann/json.git json ${git_path}
    cd ${git_path}/json
    rm -rf build
    mkdir build
    cd build
    echo $(pwd)
    cmake -DCMAKE_INSTALL_PREFIX=${HOME}/usr ..
    make install
}

gtest()
{
    update_module release-1.8.1 https://github.com/google/googletest.git googletest ${git_path}
    cd ${git_path}/googletest
    rm -rf build
    mkdir build
    cd build
    cmake -DCMAKE_INSTALL_PREFIX=${HOME}/usr ..
    make install
    # cp lib/* ${HOME}/usr/lib
    # cp -R ../googletest/include/gtest ${HOME}/usr/include
}

# demjson()
# {
#     update_module release-2.2.4 https://github.com/dmeranda/demjson.git demjson ${git_path}
#     cd ${git_path}/demjson
#     ${PYTHON} setup.py install --prefix ${HOME}/usr
# }

goget()
{
    go get -v -u golang.org/x/tools/cmd/guru \
        github.com/kisielk/errcheck \
        github.com/mdempsky/gocode \
        github.com/josharian/impl \
        golang.org/x/tools/cmd/gorename \
        golang.org/x/tools/cmd/goimports \
        github.com/stamblerre/gocode \
        honnef.co/go/tools/cmd/keyify \
        github.com/jstemmer/gotags \
        golang.org/x/lint/golint

}

updatevim()
{
    cd download_tmp
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
    if [ ! -d ~/.vim/bundle/Vundle.vim ]
    then
        git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim --depth 1
    fi
    if [ -f ~/.vimrc ]
    then 
        mv ~/.vimrc ~/.vimrc.bak
    fi
    ln -s ${PWD}/cpp.vimrc ~/.vimrc -f
    ln -s ${PWD}/base.vimrc ~/.base.vimrc -f
    # go get
    goget

    vim -u ${PWD}/cpp.vimrc +PluginInstall! +GoInstallBinaries +qall
    # vim -u ${PWD}/cpp.vimrc +PluginInstall! +qall

    cd ~/.vim/bundle/YouCompleteMe
    git submodule update --init --recursive
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

#!/bin/bash

install_dir=${HOME}/usr

# 下面不用修改

shellpath=$(dirname $(realpath $0))
shellpath=$(realpath ${shellpath}/..)
#设置mak、shell路径`
git_dir=${shellpath}/git_tmp
download_path=${shellpath}/download_tmp
cd ${shellpath}/sh
source common.sh
#cd ${shellpath}

if [ ! -d $git_dir ]
then
    echo mkdir $git_dir
    mkdir $git_dir
fi

if [ ! -d $download_path ]
then
    echo mkdir $download_path
    mkdir $download_path
fi


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
    	bash ${1}.sh ${install_dir}
    	which $1 1>/dev/null
    	if [ $? != 0 ]
	    then
            echo 手动安装$1
	        exit 1
        fi
    fi
}

PYTHON=python3
PIP3=pip3
case $MKOSTYPE in
	ubuntu)
        SUDO="sudo -H"
    ;;
    centos) 
	    SUDO="/bin/sudo -H"
    ;;
    *)
        echo unknown os type [$MKOSTYPE]
        exit 1
    ;;
esac


initdev()
{
    case $MKOSTYPE in
        ubuntu) 
            ${SUDO} apt update && ${SUDO} apt upgrade -y
    	    ${SUDO} apt install -y ccache git wget vim docker.io python3-dev build-essential ctags g++ libssl-dev python3-pip curl valgrind \
                                   python3-tk
    
                #${SUDO} apt install vim-nox vim-gnome vim-athena vim-gtk -y
                ;;
        centos) 
    	    ${SUDO} yum install -y centos-release-scl 
            ${SUDO} yum install -y devtoolset-8
            ${SUDO} yum install -y epel-release
            ${SUDO} yum update -y
            ${SUDO} yum install -y make mysql-devel wget which ccache autoconf \
            ${PYTHON} ${PYTHON}-pip ${PYTHON}-devel ${PYTHON}-tkinter \
            git bzip2 openssl-devel ncurses-devel \

            ${SUDO} curl -fsSL https://get.docker.com/ | bash
            ${SUDO} systemctl enable docker
            ${SUDO} systemctl start docker
    		${SUDO} usermod -a -G docker ${USER}
    
            # ${SUDO} yum clean all
            #提示
            source ${PWD}/env/env.sh
            ${SUDO} yum install wget
            ;;
    esac
    
    bash go.sh
    git config --global credential.helper store
    
    ${SUDO} ${PIP3} install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple
    ${SUDO} ${PIP3} install -U openpyxl \
                GitPython apio requests scons lxml mako numpy wget sqlparser pandas flake8 jaydebeapi jupyter \
		        docker-compose toml sqlparse moz-sql-parser Sphinx scrapy redis \
    		    -i https://pypi.tuna.tsinghua.edu.cn/simple

# ubuntu: sudo -H pip3 install redis -i https://pypi.tuna.tsinghua.edu.cn/simple
# centos: sudo pip3 install Sphinx -i https://pypi.tuna.tsinghua.edu.cn/simple
}



# 编译boost
boost()
{
    echo 编译boost...
    ./boost.py ${install_dir}
}

# 编译grpc
grpc()
{
    old_path=$(pwd)
    git_tmp_pull git@github.com:grpc/grpc.git
    grpc_root=${git_dir}/grpc

    echo 编译grpc...
    case $MKOSTYPE in
        ubuntu) ${SUDO} apt install -y build-essential autoconf libtool pkg-config libgflags-dev libgtest-dev clang libc++-dev ;;
        centos) ${SUDO} yum install -y build-essential autoconf libtool pkg-config libgflags-dev libgtest-dev clang libc++-dev ;;
    esac
    cd ${grpc_root}/third_party/protobuf
    ./autogen.sh
    ./configure --prefix=${install_dir}/grpc
    make -j${NUM_CPU} install
    cd ${grpc_root}
    make -j${NUM_CPU} install prefix=${install_dir}/grpc
    # go get github.com/golang/protobuf/protoc-gen-go
    cd ${old_path}
}

# 编译json
nlohmann_json()
{
    git_tmp_pull https://github.com/nlohmann/json.git
    cmake_install ${git_dir}/json ${install_dir}/nlohmann_json
}

gtest()
{
    git_tmp_pull git@github.com:google/googletest.git
    cmake_install ${git_dir}/googletest ${install_dir}/gtest
}

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
    vimdir=${git_dir}/vim
    git_tmp_pull git@github.com:vim/vim.git
    cd ${vimdir}/src
	./configure --with-features=huge --enable-pythoninterp --enable-python3interp
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
    vimdir=${shellpath}/vimrc
    if [ ! -d ~/.vim/bundle/Vundle.vim ]
    then
        mkdir -p ~/.vim/bundle
    fi
    cd ~/.vim/bundle
    git_pull git@github.com:VundleVim/Vundle.vim.git
    git_sync_pull git@github.com:ycm-core/YouCompleteMe.git
    if [ -f ~/.vimrc ]
    then
        mv ~/.vimrc ~/.vimrc.bak
    fi
    ln -s ${vimdir}/cpp.vimrc ~/.vimrc -f
    ln -s ${vimdir}/base.vimrc ~/.base.vimrc -f
    # go get

    # vim -u ${vimdir}/cpp.vimrc +PluginInstall! +GoInstallBinaries +qall
    vim -u ${vimdir}/cpp.vimrc +PluginInstall! +qall

    cd ~/.vim/bundle/YouCompleteMe
    git submodule update --init --recursive
    ${PYTHON} install.py --clang-completer # --go-completer
    if [ ! -f ~/.ycm_extra_conf.py ]
    then
        cp ${HOME}/.vim/bundle/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py ~/.ycm_extra_conf.py
    fi
}

jsoncpp()
{
    git_tmp_pull git@github.com:open-source-parsers/jsoncpp.git
    echo jsoncpp install_dir: ${install_dir}/jsoncpp
    cmake_install ${git_dir}/jsoncpp ${install_dir}/jsoncpp "-DBUILD_SHARED_LIBS=ON"
}

ffmpeg()
{
    git_tmp_pull git@github.com:FFmpeg/FFmpeg.git
    configure_install ${git_dir}/FFmpeg ${install_dir}/FFmpeg "--enable-shared --enable-static"
}

spdlog()
{
    git_tmp_pull git@github.com:gabime/spdlog.git
    cmake_install ${git_dir}/spdlog ${install_dir}/spdlog
}

gcc_install()
{
    # download_install http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-9.2.0/gcc-9.2.0.tar.gz auto configure ${install_dir}/gcc
    # sudo yum install gcc-multilib
    sudo yum install -y glibc-devel.i686 libgcc.i686 libstdc++-devel.i686 ncurses-devel.i686 texinfo
    version=9.2.0
    download http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-${version}/gcc-${version}.tar.gz
    cd gcc-${version}
    ./contrib/download_prerequisites
    mkdir build
    cd build
    ../configure --prefix=${install_dir}/gcc-${version} --enable-checking=release --enable-languages=c,c++
    make -j${NUM_CPU} install

}

echo $*
for library in $* ; do
    cd ${shellpath}/sh
    case ${library} in
    cmake)
        bash cmake.sh ${install_dir}
        ;;
    gcc)
        gcc_install
        ;;
    *)
        eval "${library}"
        ;;
    esac
done


echo 在.bashrc中增加:
echo ". ${shellpath}/env/env.sh"

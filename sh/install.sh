#!/bin/bash

# set -o errexit

install_dir=${HOME}/usr

# 下面不用修改

pro_dir=$(dirname $(realpath $0))
pro_dir=$(realpath ${pro_dir}/..)
#设置mak、shell路径`
git_dir=${pro_dir}/git_tmp
download_path=${pro_dir}/download_tmp
cd ${pro_dir}/sh
source common.sh
#cd ${pro_dir}
uid=$(id -u)

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
    INSTALL="yum install -y"
    r=$(grep "release 8" /etc/centos-release | grep -v grep)
    if [ "${r}x" != "" ]
    then
	    MKOSTYPE=centos8
    fi
else
    MKOSTYPE=$(echo `lsb_release -a 2>/dev/null |grep -i distributor| tr A-Z a-z|cut -d':' -f2`)
    INSTALL="apt install -y"
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
uid=$(id -u)
if [ ! ${uid} -eq 0 ]
then
    case $MKOSTYPE in
    	ubuntu|centos8)
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
fi



initdev()
{
    tools="lrzsz git wget ctags curl screen"
    case $MKOSTYPE in
        ubuntu) 
            ${SUDO} apt update && ${SUDO} apt upgrade -y
    	    ${SUDO} apt install -y ccache git wget docker.io python3-dev build-essential ctags g++ libssl-dev python3-pip curl valgrind \
                                   python3-tk screen lrzsz
    
                #${SUDO} apt install vim-nox vim-gnome vim-athena vim-gtk -y
                ;;
        centos|centos8) 
	        echo ${MKOSTYPE}
	        if [ ${MKOSTYPE} != 'centos8' ]
	        then
    	        ${SUDO} yum install -y centos-release-scl 
                ${SUDO} yum install -y devtoolset-8
            fi
            ${SUDO} yum install -y epel-release
            ${SUDO} yum update -y
            ${SUDO} yum install -y make mysql-devel wget which ccache autoconf \
            ${PYTHON} ${PYTHON}-pip ${PYTHON}-devel ${PYTHON}-tkinter \
                git bzip2 openssl-devel ncurses-devel screen lrzsz gdb \

            # ${SUDO} yum clean all
            #提示
            source ${PWD}/../env/env.sh
            ${SUDO} yum install wget
            ;;
    esac
    
    # bash go.sh
    git config --global credential.helper store
    
    ${SUDO} ${PIP3} install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple
    ${SUDO} ${PIP3} install -U openpyxl \
                GitPython apio requests scons lxml mako numpy wget sqlparser pandas flake8 jaydebeapi jupyter \
		        docker-compose toml sqlparse moz-sql-parser Sphinx scrapy redis json5 gitpython
     \
    		    -i https://pypi.tuna.tsinghua.edu.cn/simple

# ubuntu: sudo -H pip3 install redis -i https://pypi.tuna.tsinghua.edu.cn/simple
# centos: sudo pip3 install Sphinx -i https://pypi.tuna.tsinghua.edu.cn/simple
}

install_docker()
{
    version=1.2.6-3.3
    # cd ${download_dir}
    ${SUDO} dnf install https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-${version}.el7.x86_64.rpm
    # sudo rpm -i containerd.io-${version}.el7.x86_64.rpm
    ${SUDO} yum install -y yum-utils device-mapper-persistent-data lvm2
    ${SUDO} yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    ${SUDO} yum install docker-ce docker-ce-cli containerd.io
    # ${SUDO} curl -fsSL https://get.docker.com/ | bash
    # ${SUDO} systemctl enable docker
    # ${SUDO} systemctl start docker
    # ${SUDO} usermod -a -G docker ${USER}
}



# 编译boost
boost()
{
    echo 编译boost...
    if [ ${uid} -eq 0 ]
    then
        ./boost.py /root/usr
    else
        ./boost.py ${install_dir}
    fi

}

# 编译grpc
grpc()
{
    old_path=$(pwd)
    cd ${git_dir}
    git_sync_pull https://github.com/grpc/grpc.git
    grpc_root=${git_dir}/grpc

    echo 编译grpc...
    case $MKOSTYPE in
        ubuntu) ${SUDO} apt install -y build-essential autoconf libtool pkg-config libgflags-dev libgtest-dev clang libc++-dev ;;
        centos|centos8) ${SUDO} yum install -y build-essential autoconf libtool pkg-config libgflags-dev libgtest-dev clang libc++-dev ;;
    esac
    cd ${grpc_root}/third_party/protobuf
    ./autogen.sh
    ./configure --prefix=${install_dir}/grpc
    make -j${PHYSICAL_NUM} install
    cd ${grpc_root}
    make -j${PHYSICAL_NUM} install prefix=${install_dir}/grpc
    # go get github.com/golang/protobuf/protoc-gen-go
    cd ${old_path}
}

# 编译json
nlohmann_json()
{
    # git_tmp_pull https://github.com/nlohmann/json.git
    git_tmp_pull https://github.com/nlohmann/json.git
    cmake_install ${git_dir}/json ${install_dir}/nlohmann_json "-DBUILD_TESTING=OFF"
}

gtest()
{
    git_tmp_pull https://github.com/google/googletest.git
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
    go get -u github.com/golang/protobuf/protoc-gen-go

}

updatevim()
{
    vimdir=${git_dir}/vim
    git_tmp_pull https://github.com/vim/vim.git
    configure_install ${vimdir}/src ${install_dir}/vim "--with-features=huge --enable-pythoninterp --enable-python3interp"
    return $?
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
    vimdir=${pro_dir}/vimrc
    if [ ! -d ~/.vim/bundle/Vundle.vim ]
    then
        mkdir -p ~/.vim/bundle
    fi
    cd ~/.vim/bundle
    git_pull https://github.com/VundleVim/Vundle.vim.git
    git_pull https://github.com/nvie/vim-flake8.git
    git_pull https://github.com/SirVer/ultisnips.git
    git_pull https://github.com/majutsushi/tagbar.git
    git_pull https://github.com/Raimondi/delimitMate.git
    git_sync_pull https://github.com/ycm-core/YouCompleteMe.git
    if [ ! $? -eq 0 ]
    then
        echo "clone https://github.com/ycm-core/YouCompleteMe.git error"
        return 1
    fi
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
    # git submodule update --init --recursive
    ${PYTHON} install.py --clang-completer # --go-completer
    if [ ! -f ~/.ycm_extra_conf.py ]
    then
        cp ${HOME}/.vim/bundle/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py ~/.ycm_extra_conf.py
    fi
}

jsoncpp()
{
    git_tmp_pull https://github.com/open-source-parsers/jsoncpp.git
    echo jsoncpp install_dir: ${install_dir}/jsoncpp
    cmake_install ${git_dir}/jsoncpp ${install_dir}/jsoncpp "-DBUILD_SHARED_LIBS=ON"
}

libx264()
{
    git_tmp_pull https://github.com/mirror/x264.git
    configure_install ${git_dir}/x264 ${install_dir}/libx264 "--enable-shared --disable-asm"
}

FFmpeg()
{
    ffmpeg
}

ffmpeg()
{
    git_tmp_pull https://github.com/FFmpeg/FFmpeg.git
    if [ ${uid} -eq 0 ]
    then
        configure_install ${git_dir}/FFmpeg ${install_dir}/FFmpeg "--enable-shared --enable-static --enable-gpl --enable-libx264 --extra-cflags=-I/root/usr/include --extra-ldflags=-L/root/usr/lib"
    else
        configure_install ${git_dir}/FFmpeg ${install_dir}/FFmpeg "--enable-shared --enable-static --enable-gpl --enable-libx264 --extra-cflags=-I${install_dir}/x264/include --extra-ldflags=-L${install_dir}/x264/lib"
    fi
}

spdlog()
{
    git_tmp_pull https://github.com/gabime/spdlog.git
    cmake_install ${git_dir}/spdlog ${install_dir}/spdlog
}

gcc_install()
{
    # download_install http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-9.2.0/gcc-9.2.0.tar.gz auto configure ${install_dir}/gcc
    # sudo yum install gcc-multilib
    ${SUDO} yum install -y glibc-devel.i686 libgcc.i686 libstdc++-devel.i686 ncurses-devel.i686 texinfo
    version=9.2.0
    download http://ftp.tsukuba.wide.ad.jp/software/gcc/releases/gcc-${version}/gcc-${version}.tar.gz
    cd gcc-${version}
    ./contrib/download_prerequisites
    mkdir build
    cd build
    ../configure --prefix=${install_dir}/gcc-${version} --enable-checking=release --enable-languages=c,c++
    make -j${PHYSICAL_NUM} install
}

zlib()
{
    version=1.2.11
    download https://www.zlib.net/zlib-${version}.tar.gz
    cmake_install ${download_dir}/zlib-${version} ${install_dir}/zlib
}

quazip()
{
    git_tmp_pull https://github.com/stachenov/quazip.git
    qmake_install ${git_dir}/quazip ${install_dir}/quazip
}

install_cmake()
{
    curr_version=$(cmake --version | head -n1 | cut -d' ' -f3)
    version=3.16.4
    if [ "${curr_version}x" == "${version}x" ]
    then
        return 0
    fi
    download https://github.com/Kitware/CMake/releases/download/v${version}/cmake-${version}.tar.gz
    configure_install ${download_dir}/cmake-${version} ${install_dir}/cmake
}

install_openssl()
{
    version=1.1.1d
    version=1.1.1f
    # download https://www.openssl.org/source/openssl-${version}.tar.gz
    # configure_install ${download_dir}/openssl-${version} ${install_dir}/openssl
    git_tmp_pull https://github.com/openssl/openssl.git
    configure_install ${git_dir}/openssl ${install_dir}/openssl
}

aliyun_oss()
{
    ${SUDO} ${INSTALL} libcurl4-openssl-dev
    ${SUDO} ${INSTALL} libcurl-devel
    git_tmp_pull https://github.com/aliyun/aliyun-oss-cpp-sdk.git
    # git_tmp_pull git@github.com:aliyun/aliyun-oss-cpp-sdk.git
    cmake_install ${git_dir}/aliyun-oss-cpp-sdk ${install_dir}/aliyun-oss-cpp-sdk
}

rapidjson()
{
    git_commit_pull https://github.com/Tencent/rapidjson.git
    cmake_install ${git_dir}/rapidjson ${install_dir}/rapidjson
}

sqlite3()
{
    version=202002271621
    download https://www.sqlite.org/snapshot/sqlite-snapshot-${version}.tar.gz
    configure_install ${download_dir}/sqlite-snapshot-${version} ${install_dir}/sqlite3
}

install_git()
{
    version=2.26.0
    download https://mirrors.edge.kernel.org/pub/software/scm/git/git-${version}.tar.gz
}

libev()
{
    git_tmp_pull https://github.com/enki/libev.git
    configure_install ${git_dir}/libev ${install_dir}/libev
    # version=1.8.0
    # download https://www.freedesktop.org/software/libevdev/libevdev-${version}.tar.xz
}

install_redis()
{
    download http://download.redis.io/redis-stable.tar.gz
    cd ${download_dir}/redis-stable
    make -j${PHYSICAL_NUM}
    make PREFIX=${install_dir}/redis install
}

hiredis()
{
    git_tmp_pull https://github.com/redis/hiredis.git
    cmake_install ${git_dir}/hiredis ${install_dir}/hiredis
}

hiredis-vip()
{
    git_tmp_pull https://github.com/vipshop/hiredis-vip.git
    cd ${git_dir}/hiredis-vip
    make -j${PHYSICAL_NUM}
    if [ ${uid} -eq 0 ]
    then
    	make PREFIX=${install_dir} install
    else
    	make PREFIX=${install_dir}/hiredis-vip install
    fi
}

hiredis-v()
{
    git_tmp_pull https://github.com/wuli1999/hiredis-v.git
    cd ${git_dir}/hiredis-v/src
    make -j${PHYSICAL_NUM}
    if [ ${uid} == 0 ]
    then
        make PREFIX=${install_dir} install
        mkdir ${install_dir}/lib
        cp librediscluster.a librediscluster.so ${install_dir}/lib
    else
        make PREFIX=${install_dir}/hiredis-v install
        mkdir ${install_dir}/hiredis-v/lib
        cp librediscluster.a librediscluster.so ${install_dir}/hiredis-v/lib
    fi
}

tcmalloc()
{
    ${SUDO} ${INSTALL} autoconf automake libtool
    git_tmp_pull https://github.com/gperftools/gperftools.git
    cd ${git_dir}/gperftools
    ./autogen.sh
    configure_install ${git_dir}/gperftools ${install_dir}/gperftools
}

muduo()
{
    # ${SUDO} apt-get install protobuf-compiler
    git_tmp_pull https://github.com/chenshuo/muduo.git
    cd ${git_dir}/muduo
    sed -i 's@-Wconversion@#-Wconversion@g' CMakeLists.txt
    sed -i 's@-Wold-style-cast@#-Wold-style-cast@g' CMakeLists.txt
    cmake_install ${git_dir}/muduo ${install_dir}/muduo "-DMUDUO_BUILD_EXAMPLES=OFF"
    # if [ ${uid} -eq 0 ]
    # then
    #     sed -i 's@INSTALL_DIR=.*@INSTALL_DIR=${HOME}/usr@g' build.sh
    # else
    #     sed -i 's@INSTALL_DIR=.*@INSTALL_DIR=${HOME}/usr/muduo@g' build.sh
    # fi
    # ./build.sh
}

opencv()
{
    version=3.3.0
    # version=3.4.1
    version=3.4.2
    version=4.2.0
    download https://github.com/opencv/opencv/archive/${version}.zip opencv-${version}
    cd ${download_dir}/opencv-${version}
    cmake_install ${download_dir}/opencv-${version} ${install_dir}/opencv-${version}
    unlink ${install_dir}/opencv || true
    ln -s opencv-${version} ${install_dir}/opencv
}

yasm()
{
    git_tmp_pull https://github.com/yasm/yasm.git
    cmake_install ${git_dir}/yasm ${install_dir}/yasm
}

install_ccache()
{
    version=3.7.9
    download https://github.com/ccache/ccache/releases/download/v${version}/ccache-${version}.tar.gz
    configure_install ${download_dir}/ccache-${version} ${install_dir}/ccache
}

mysql_conn_cpp()
{
    # version=8.0.19
    # download https://cdn.mysql.com//Downloads/Connector-C++/mysql-connector-c++-${version}-src.tar.gz

    version=1.1.12
    download https://cdn.mysql.com//Downloads/Connector-C++/mysql-connector-c++-${version}.tar.gz
    flags="-DBUILD_STATIC=ON -DBUNDLE_DEPENDENCIES=ON -DWITH_JDBC=ON -DMYSQL_LIB_DIR="
    cxxflags="-DMYCPPCONN_MAJOR_VERSION=8 -DMYCPPCONN_MINOR_VERSION=0 -DMYCPPCONN_PATCH_VERSION=19"
    if [ ${uid} -eq 0 ]
    then
        cmake_install ${download_dir}/mysql-connector-c++-${version} ${install_dir}/mysql_conn_cpp "-DBOOST_ROOT=/root/usr ${flags}"
    else
        cmake_install ${download_dir}/mysql-connector-c++-${version} ${install_dir}/mysql_conn_cpp "-DBOOST_ROOT=${HOME}/usr/boost ${flags}"
    fi
    # git_tmp_pull https://github.com/anhstudios/mysql-connector-cpp.git
    # cmake_install ${git_dir}/mysql-connector-cpp ${install_dir}/mysql-connector-cpp
    # version=1.1.13
    # download https://cdn.mysql.com//Downloads/Connector-C++/mysql-connector-c++-${version}.tar.gz
    # flags="-DBUILD_STATIC=ON -DBUNDLE_DEPENDENCIES=ON -DWITH_JDBC=ON -DMYSQL_LIB_DIR=/usr/lib64/mysql -DMYSQL_INCLUDE_DIR="
    # cxxflags="-DMYCPPCONN_MAJOR_VERSION=8 -DMYCPPCONN_MINOR_VERSION=0 -DMYCPPCONN_PATCH_VERSION=19"
    # if [ ${uid} -eq 0 ] 
    # then
    #     cmake_install ${download_dir}/mysql-connector-c++-${version} ${install_dir}/mysql_conn_cpp "-DBOOST_ROOT=/root/usr ${flags}"
    # else
    #     cmake_install ${download_dir}/mysql-connector-c++-${version} ${install_dir}/mysql_conn_cpp "-DBOOST_ROOT=${HOME}/usr/boost ${flags}"
    # fi
    # git_tmp_pull https://github.com/anhstudios/mysql-connector-cpp.git
    git_tmp_pull https://github.com/mysql/mysql-connector-cpp.git
    cmake_install ${git_dir}/mysql-connector-cpp ${install_dir}/mysql_conn_cpp
}

cryptopp()
{
    git_tmp_pull https://github.com/weidai11/cryptopp.git
    cd ${git_dir}/cryptopp
    if [ ${uid} -eq 0 ]
    then
        mkdir -p ${install_dir}
        make -j${PHYSICAL_NUM}
        make PREFIX=${install_dir} install
    else
        mkdir -p ${install_dir}/cryptopp
        make -j${PHYSICAL_NUM}
        make PREFIX=${install_dir}/cryptopp install
    fi
}

echo $*
for library in $* ; do
    cd ${pro_dir}/sh
    case ${library} in
    ccache)
        install_ccache
        ;;
    redis)
        install_redis
        ;;
    docker)
        install_docker
        ;;
    git)
        install_git
        ;;
    cmake)
        install_cmake
        ;;
    gcc)
        install_gcc
        ;;
    openssl)
        install_openssl
        ;;
    *)
        eval "${library}"
        ;;
    esac
done


echo 在.bashrc中增加:
echo ". ${pro_dir}/env/env.sh"

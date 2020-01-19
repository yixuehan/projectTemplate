#!/bin/bash
if [ $# -lt 1 ]
then
    echo usage: $0 install_dir
    exit 1
fi
install_dir=$1
source common.sh
echo 编译json...
repo=https://github.com/nlohmann/json.git
git_pull ${repo}
repodir=$(basename ${repo} | cut -d'.' -f1)
cd ${gitdir}
cd ${repodir}
rm -rf build
mkdir build
cd build
echo $(pwd)
cmake -DCMAKE_INSTALL_PREFIX=${install_dir} ..
make install

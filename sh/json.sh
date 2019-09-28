#!/bin/bash
. tool.sh
git_path=../git_tmp
echo 编译json...
update_module v3.7.0 https://github.com/nlohmann/json.git json ${git_path}
cd ${git_path}/json
rm -rf build
mkdir build
cd build
echo $(pwd)
cmake -DCMAKE_INSTALL_PREFIX=${HOME}/usr/json ..
make install

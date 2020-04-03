#!/bin/bash
for cmd in $@
do
    echo ${cmd}
done

# exit 1


source ../../syncgit.sh
cwd=${PWD}
cd ../../
git_dir=${PWD}
download_path=${git_dir}/.git_download
cd ${cwd}

set -o errexit

update_module https://github.com/nlohmann/json.git json ${download_path}

cd ${cwd}
make git_dir=${git_dir} download_path=${git_dir}/.git_download cwd=${cwd} $*



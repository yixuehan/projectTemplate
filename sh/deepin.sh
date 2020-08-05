#!/bin/bash
git_dir=../git_tmp/deepin-wine-for-ubuntu
git clone https://gitee.com/wszqkzqk/deepin-wine-for-ubuntu.git ${git_dir}
cd ${git_dir}
./install.sh

#!/usr/bin/env python3
# -*- coding: utf-8 -*-


import git
import os
import sys
# import threading
from multiprocessing import Pool

git_tmp_dir = "git_tmp"


def git_download(url, basename=None):
    if not basename:
        basename = os.path.basename(url)
        basename.replace(".git", "")
    dst_dir = os.path.join(os.path.abspath("."), git_tmp_dir, basename)
    git.Repo.clone_from(url, dst_dir, multi_options=["--depth=1"])


def cd_file_path(file_path):
    dir_path = os.path.dirname(file_path)
    print(dir_path)
    os.chdir(dir_path)
    print(os.path.abspath("."))


if __name__ == '__main__':
    file_path = sys.argv[0]
    cd_file_path(file_path)
    # task = git_download("git@github.com:nlohmann/json.git", "nlohmann_json")
    # tasks = []
    processs = []
    pool = Pool(10)
    for repo in [
            "git@github.com:grpc/grpc.git",
            ("git@github.com:nlohmann/json.git", "nlohmann_json"),
            "git@github.com:google/googletest.git",
            "git@github.com:vim/vim.git"
            ]:
        if isinstance(repo, tuple) or isinstance(repo, list):
            dirname = None
            if len(repo) > 1:
                dirname = repo[1]
            pool.apply_async(git_download,
                             args=(repo[0], dirname))
        else:
            pool.apply_async(git_download, args=(repo,))

    pool.close()
    pool.join()

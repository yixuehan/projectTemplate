#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import threading
import sys
sys.path.append("..")
from util.python.util import run_cmd
# import pdb

def git_version():
    cmd = "git version | cut -d ' ' -f3"
    r = run_cmd(cmd, show=False)
    versions = r[0].split('.')
    # 越界？应该报错
    return int(versions[0]), int(versions[1]), int(versions[2])


def check_repo(repo_dir):
    if not os.path.exists(repo_dir) or not os.path.exists(os.path.join(repo_dir, '.git')):
        return False
    cmd = "cd %s && git log" % repo_dir
    r = run_cmd(cmd, show=False)
    if len(r) == 1 and -1 != r[0].find("fatal"):
        return False
    return True


def git_clone(repo, local_dir, options, submodule_options):
    cmd = ["git", "clone", repo, local_dir] + options
    run_cmd(cmd)
    cmd = "cd %s && git submodule update --init --recursive" % local_dir
    v1, v2, v3 = git_version()
    for option in submodule_options:
        if v1 < 2:
            if -1 != option.find("--depth"):
                continue
        
        cmd = cmd + ' ' + option
    run_cmd(cmd)
    return True


def is_realpath(p):
    assert len(p) > 0
    return p[0] == '/'


class RepoInfo:
    def __init__(self, repo, local_dir, options, submodule_options):
        self.repo = repo
        self.local_dir = os.path.realpath(local_dir)
        self.options = options
        self.submodule_options = submodule_options


class Git:
    def __init__(self, git_dir):
        self.__git_dir = git_dir
        self.__repoinfos = []

    def append(self, repo, local_dir=None, options=[], submodule_options=[]):
        assert isinstance(options, list)
        assert isinstance(submodule_options, list)
        if not local_dir:
            local_dir = os.path.basename(repo)
            local_dir = local_dir.replace(".git", "")

        is_real = is_realpath(local_dir)
        if not is_real:
            local_dir = os.path.join(self.__git_dir, local_dir)

        if check_repo(local_dir):
            return
        elif os.path.exists(local_dir):
            os.removedirs(os.path.join(self.__git_dir, local_dir))

        self.__repoinfos.append(RepoInfo(repo, local_dir, options, submodule_options))

    def clone(self):
        threads = []
        print(self.__repoinfos)
        # pdb.set_trace()
        for repoinfo in self.__repoinfos:
            print("clone:", repoinfo.repo)
            t = threading.Thread(target=git_clone, args=(repoinfo.repo, repoinfo.local_dir,
                                 repoinfo.options, repoinfo.submodule_options))
            threads.append(t)
            t.start()

        for t in threads:
            print("join:", repoinfo.repo)
            t.join()

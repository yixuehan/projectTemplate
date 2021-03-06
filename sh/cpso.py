#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# import os
import sys
import subprocess
import shutil


def __get_so_list(program, so_set):
    # new_set = set()
    p = subprocess.Popen('ldd %s' % program,
                         shell=True, stdout=subprocess.PIPE)
    out, err = p.communicate()
    # print("out:", out)
    # print("err:", err)
    if err:
        print(err)
        assert False
    for line in out.splitlines():
        line = str(line)
        # print(line)
        if line.find("=> /") != -1:
            so = line.split(' ')[2]
            print(so)
            if so not in so_set:
                so_set.add(so)
                __get_so_list(program, so_set)
    return list(so_set)


def get_so_list(program):
    so_set = set()
    return __get_so_list(program, so_set)


def cp_files(files):
    for f in files:
        shutil.copy(f, '.')


if __name__ == '__main__':
    so_list = get_so_list(sys.argv[1])
    cp_files(so_list)


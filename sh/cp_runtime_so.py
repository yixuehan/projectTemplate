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


def get_runtime_so(program, find_handle):
    p = subprocess.Popen('ldd %s' % program,
                         shell=True, stdout=subprocess.PIPE)
    out, err = p.communicate()
    print(err)
    so = find_handle(err)
    print("find so:", so)
    return so


def cp_files(files):
    for f in files:
        shutil.copy(f, '.')


def tdlc_find_handle(output):
    output = ""
    msg = "error.Errmsg"
    index = output.index(msg)
    return output[index+2:index+2+len(msg)]


if __name__ == '__main__':
    so = get_runtime_so(sys.argv[1], tdlc_find_handle)
    so_set = set(so)
    so_copy = set()
    while so:
        __get_so_list(so, so_set)
        for so in so_set:
            if so not in so_copy:
                cp_files([so])
                so_copy.add(so)
        so = get_runtime_so(sys.argv[1], tdlc_find_handle)

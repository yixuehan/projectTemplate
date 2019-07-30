#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os


def assert_unique(l, value):
    if value in l:
        print("value [%s] exist" % value)
        assert False


def abs_path(path):
    if path[0] == '~':
        path = os.environ['HOME'] + path[1:]
    return os.path.abspath(path)


def assert_file(filename):
    if not os.path.exists(filename):
        print("file [%s] not exist" % (filename))
        assert False


def gen_upper_camel(name):
    if -1 == name.find('_'):
        name = name[0].upper() + name[1:]
        return name
    names = name.split('_')
    name = ""
    for n in names:
        name += n.title()
    return name


def gen_lower_camel(name):
    name = gen_upper_camel(name)
    return name[0].lower() + name[1:]


def gen_underline_name(name):
    res = ''
    for c in name:
        if c.upper() == c:
            res = res + '_' + c.lower()
        else:
            res = res + c
    return res

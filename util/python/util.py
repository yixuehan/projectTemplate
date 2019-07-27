#!/usr/bin/env python3
# -*- coding: utf-8 -*-


def assert_unique(l, value):
    if value in l:
        print("value [%s] exist" % value)
        assert False

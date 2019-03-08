#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import requests
import wget
import os
from lxml import html
import hashlib
import shutil
import platform
# import bz2


url = 'https://www.boost.org/'
findpath = '//div[@id="downloads"]/ul/li/div[@class="news-title"]/a/@href'
downloadfilefind = '//table[@class="download-table"]//tr[2]/td/a/@href'
downloadhashfind = '//table[@class="download-table"]//tr[2]/td[2]/text()'
installdir = '${HOME}/usr'


def get_filepath(tree):
    filepath = tree.xpath(findpath)
    if len(filepath) != 1:
        print("未找到文件链接")
        assert False
    filepath = filepath[0]
    return filepath


def get_version(filepath):
    basefile = os.path.basename(filepath)
    version = basefile.split(".")[0]
    return version


def get_filename(version):
    version = version.replace("version", "boost", 1)
    return version + ".tar.bz2"


def get_download_table_node(tree, downloadpath):
    print(downloadpath)
    node = tree.xpath(downloadpath)
    print(node)


def download_file(tree, filename):
    downloadpath = tree.xpath(downloadfilefind)
    downloadhash = tree.xpath(downloadhashfind)
    if len(downloadpath) != 1:
        print("获取下载路径失败！")
        assert False
    downloadpath = downloadpath[0]
    if len(downloadhash) != 1:
        print("获取文件hash！")
        assert False
    downloadhash = downloadhash[0]
    print(downloadpath, downloadhash, filename)
    # downloadpath = downloadpath.encode("utf8")
    if os.path.exists(filename):
        hashcode = hashlib.sha256(open(filename, "rb").read()).hexdigest()
        print("hash:", hashcode)
        if hashcode == downloadhash:
            print("hash值相同，不需要下载")
            return
        else:
            print("hash值不同，重新下载")
            shutil.move(filename, filename + ".bak")

    print("downloading...")
    wget.download(downloadpath)


def compile_install_boost(filename):
    # 解压
    # dec = bz2.BZ2Decompressor()
    dirname = filename.split('.')[0]
    if 'Linux' == platform.system():
        cmd = 'tar -jxf ' + filename
        os.system(cmd)

        os.chdir(dirname)

        cmd = 'rm -f project-config.jam*'
        os.system(cmd)

        cmd = './bootstrap.sh --libdir=${HOME}/usr/lib --includedir=${HOME}/usr/include'
        os.system(cmd)

        cmd = './bjam cxxflags="-std=c++1z" variant=release install'
        return os.system(cmd)


def compare_hash(url, filename):
    pass


if __name__ == '__main__':
    # print(hashlib.sha256("abc".encode("utf8")).hexdigest())
    # os.sys.exit(1)
    resp = requests.get(url)
    tree = html.fromstring(resp.text)
    filepath = get_filepath(tree)
    version = get_version(filepath)
    filename = get_filename(version)
    # download
    downloadweb = url + filepath
    resp = requests.get(downloadweb)
    # print(resp.text)
    tree = html.fromstring(resp.text)
    # downloadpath = downloadpath % filename
    # get_download_table_node(tree, downloadfilefind)
    download_file(tree, filename)
    compile_install_boost(filename)

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
    print(filepath)
    if len(filepath) == 0:
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
        print("获取文件hash失败！")
        assert False
    downloadhash = downloadhash[0]

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
    os_type = platform.system()
    linux_type = os.environ['MKOSTYPE']
    linux_dirname = dirname + "_" + linux_type
    if 'Linux' == os_type:
        if not os.path.exists(linux_dirname):
            if not os.path.exists(dirname):
                print("解压...", filename)
                cmd = 'tar -jxf ' + filename
                os.system(cmd)
            cmd = 'mv %s %s' % (dirname, linux_dirname)
            print("改名：", cmd)
            os.system(cmd)

        os.chdir(linux_dirname)

        cmd = 'rm -f project-config.jam*'
        os.system(cmd)

        home = os.environ['HOME']

        cmd = './bootstrap.sh --libdir=%(HOME)s/usr/%(boost)s/lib --includedir=%(HOME)s/usr/%(boost)s/include'
        cmd = cmd % {'HOME': home,
                     'boost': dirname}
        os.system(cmd)

        cmd = './bjam cxxflags="-std=c++1z" variant=release install'
        os.system(cmd)

        # 建立软链接
        link_include = '%s/usr/include/boost' % (home)
        if os.path.exists(link_include):
            os.remove(link_include)

        link_lib = '%s/usr/lib/boost' % (home)
        if os.path.exists(link_lib):
            os.remove(link_lib)

        os.symlink("%s/usr/%s/include/boost" % (home, dirname), link_include)
        os.symlink("%s/usr/%s/lib" % (home, dirname), link_lib)


if __name__ == '__main__':
    resp = requests.get(url)
    # print(resp.text)
    tree = html.fromstring(resp.text)
    filepath = get_filepath(tree)
    version = get_version(filepath)
    filename = get_filename(version)
    # download
    downloadweb = url + filepath
    resp = requests.get(downloadweb)
    tree = html.fromstring(resp.text)
    download_file(tree, filename)
    compile_install_boost(filename)

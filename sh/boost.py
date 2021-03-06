#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# import requests
import getpass
import wget
import os
from lxml import html
import hashlib
import shutil
import platform
import subprocess
from subprocess import PIPE, STDOUT
# import bz2


url = 'https://www.boost.org'
findpath = '//div[@id="downloads"]/ul/li/div[@class="news-title"]/a/@href'
downloadfilefind = '//table[@class="download-table"]//tr[2]/td/a/@href'
downloadhashfind = '//table[@class="download-table"]//tr[2]/td[2]/text()'
downloaddir = os.path.join("..", 'download_tmp')
boost_install_dir = ""


def get_filepath(tree):
    filepath = tree.xpath(findpath)
    print(filepath)
    if len(filepath) == 0:
        # print("未找到文件链接")
        assert False
    filepath = filepath[0]
    # print(filepath)
    # return "/users/history/version_1_70_0.html"
    # return "/users/history/version_1_58_0.html"
    return filepath


def get_version(filepath):
    basefile = os.path.basename(filepath)
    version = basefile.split(".")[0]
    print(version)
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
        # print("获取下载路径失败！")
        assert False
    downloadpath = downloadpath[0]

    # filename = os.path.join(downloaddir, filename)

    if os.path.exists(filename):
        if len(downloadhash) != 1:
            # print("获取文件hash失败！")
            downloadhash = [hashlib.sha256(open(filename, "rb").read()).hexdigest()]
            # assert False
        downloadhash = downloadhash[0]

        hashcode = hashlib.sha256(open(filename, "rb").read()).hexdigest()
        print("hash:", hashcode)
        if hashcode == downloadhash:
            # print("hash值相同，不需要下载")
            return
        else:
            # print("hash值不同，重新下载")
            shutil.move(filename, filename + ".bak")

    print("downloading...")
    print(downloadpath)
    wget.download(downloadpath)


def compile_install_boost(filename):
    # 解压
    dirname = filename.split('.')[0]
    os_type = platform.system()
    linux_type = os.environ['MKOSTYPE']
    linux_dirname = dirname + "_" + linux_type
    if 'Linux' == os_type:
        print("dirname:", dirname)
        print("linux_dirname:", linux_dirname)
        if not os.path.exists(linux_dirname):
            if os.path.exists(dirname):
                shutil.rmtree(dirname)

            # print("解压...", filename)
            cmd = 'tar -jxf ' + filename
            r = subprocess.Popen(cmd, bufsize=0, stdout=PIPE, stderr=PIPE, shell=True)
            print(r.stdout.read())
            # assert 0 == os.system(cmd)
            cmd = 'mv %s %s' % (dirname, linux_dirname)
            # print("改名：", cmd)
            r = subprocess.Popen(cmd, bufsize=0, stdout=PIPE, stderr=PIPE, shell=True)
            print(r.stdout.read())
            # assert 0 == os.system(cmd)

        os.chdir(linux_dirname)

        cmd = 'rm -f project-config.jam*'
        r = subprocess.Popen(cmd, bufsize=0, stdout=PIPE, stderr=PIPE, shell=True)
        print(r.stdout.read())
        # os.system(cmd)

        # home = os.environ['HOME']

        # print("home:[%s] dirname:[%s]" % (home, dirname))
        print("dirname:[%s]" % (dirname))
        # assert home
        assert dirname
        # boost_dir = boost_install_dir
        # install_dir = os.path.join(boost_dir, dirname)
        global boost_install_dir
        link_dir = os.path.join(boost_install_dir, 'boost')
        boost_install_dir = os.path.join(boost_install_dir, dirname)

        # bugs
        # unset CPLUS_INCLUDE_PATH
        if 'root' == getpass.getuser():
            boost_install_dir = '/root/usr'

        cmd = 'unset CPLUS_INCLUDE_PATH && ./bootstrap.sh --libdir=%(install_dir)s/lib \
                --includedir=%(install_dir)s/include --with-python=$(which python3)'
        cmd = cmd % {'install_dir': boost_install_dir}

        print(cmd)
        r = subprocess.Popen(cmd, bufsize=0, stdout=PIPE, stderr=PIPE, shell=True)
        print(r.stdout.read())
        # os.system(cmd)

        cmd = './b2 cxxflags="-std=c++1z" variant=release install'
        print(cmd)
        r = subprocess.Popen(cmd, bufsize=0, stdout=PIPE, stderr=PIPE, shell=True)
        while True:
            line = r.stdout.readline()
            if not line:
                break
            print(line)
        # os.system(cmd)

        # 建立软链接
        if 'root' != getpass.getuser():
            print("link_dir:", link_dir)
            if os.path.islink(link_dir):
                os.unlink(link_dir)

            print("ln -s %s %s" % (dirname, link_dir))
            os.symlink(dirname, link_dir)
    else:
        # print("不支持的系统...", os_type)
        assert False


if __name__ == '__main__':
    if len(os.sys.argv) < 2:
        print("usage: %s boost_install_dir" % os.sys.argv[0])
        assert False
    boost_install_dir = os.path.abspath(os.sys.argv[1])
    os.chdir(downloaddir)
    # resp = requests.get(url)
    r = subprocess.Popen(args=["curl", url], stdout=PIPE, stderr=STDOUT)
    resp = r.stdout.read()
    print(resp)
    # os.sys.exit(1)

    # print(resp.text)
    tree = html.fromstring(resp)
    filepath = get_filepath(tree)
    version = get_version(filepath)
    filename = get_filename(version)
    # download
    downloadweb = url + filepath
    # resp = requests.get(downloadweb)
    print(downloadweb)
    r = subprocess.Popen(args=["curl", downloadweb], stdout=PIPE, stderr=STDOUT)
    resp = r.stdout.read()
    print(resp)
    tree = html.fromstring(resp)
    download_file(tree, filename)
    compile_install_boost(filename)

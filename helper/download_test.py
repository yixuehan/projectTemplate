#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import unittest
from download import Git, git_clone


class DownloadTest(unittest.TestCase):
    def test_clone(self):
        git_clone("https://github.com/yixuehan/study.git", "study2", ["--depth=1"], ["--depth=1"])
        git = Git("git_tmp")
        git.append("https://github.com/yixuehan/study.git")
        git.append("https://github.com/yixuehan/study.git", "study2", ["--depth=1"])
        git.append("https://github.com/yixuehan/study.git", "testdir/study3")
        git.append("https://github.com/yixuehan/projectTemplate.git", options=["--depth=1"],
                   submodule_options=["--depth=1"])
        git.clone()


if __name__ == '__main__':
    unittest.main()

#!/bin/bash
# GIT_PROXY=
alias git_proxy="git config --global http.proxy 'socks5://${GIT_PROXY}' && git config --global https.proxy 'socks5://${GIT_PROXY}'"
alias unset_git_proxy="git config --global --unset http.proxy && git config --global --unset https.proxy"

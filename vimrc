"" 配置主题
"set t_Co=256
"
"colorscheme molokai
"
"let g:molokai_original = 1
"
"let g:rehash256 = 1
"" F2 行号开关，用于鼠标复制代码用
"" 为方便复制，用<F2>开启/关闭行号显示:
autocmd BufReadPre,BufNewFile *.cpp,*.h,*.hpp,*.c,*.ipp exec ":source ~/.cpp.vimrc"
autocmd BufReadPre,BufNewFile *.go source ~/.go.vimrc
"source ~/.cpp.vimrc
function! HideNumber()
  if(&relativenumber == &number)
    set relativenumber! number!
  elseif(&number)
    set number!
  else
    set relativenumber!
  endif
  set number?
endfunc
nnoremap <F2> :call HideNumber()<CR>
"
au InsertLeave * set nopaste
"
set rnu
set number
set ffs=unix
"set mouse=a
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
set tabstop=4
set expandtab
set softtabstop=4
set autoindent
set smartindent
set cindent
set shiftwidth=4
filetype on
filetype plugin on
filetype indent on
autocmd FileType make set noexpandtab
set tags=tags;
set termencoding=utf-8
set encoding=utf-8
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936,big5,latin-1
set nohlsearch
"
set pastetoggle=<F5>
"
"
"
"
"" 定义函数AutoSetFileHead，自动插入文件头
autocmd BufNewFile *.sh,*.py,*.go exec ":call AutoSetFileHead()"
function! AutoSetFileHead()
    "如果文件类型为.sh文件
    if &filetype == 'sh'
        call setline(1, "\#!/bin/bash")
    endif

    "如果文件类型为python
    if &filetype == 'python'
        call setline(1, "\#!/usr/bin/env python3")
        call setline(2, "\# -*- coding: utf-8 -*-")
    endif

    normal G
    normal o
    normal o
endfunc

"" 配置主题
"set t_Co=256
"
"colorscheme molokai
"
"let g:molokai_original = 1
"
"let g:rehash256 = 1
set nocompatible
filetype off 
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'fatih/vim-go'
Plugin 'Valloric/YouCompleteMe'
Plugin 'nsf/gocode', {'rtp': 'vim/'}
Plugin 'SirVer/ultisnips'
Plugin 'scrooloose/nerdtree'
Plugin 'majutsushi/tagbar'
Plugin 'Raimondi/delimitMate'
Plugin 'nvie/vim-flake8'
call vundle#end()
filetype plugin indent on

"Flake8
let g:flake8_quickfix_height = 7 
highlight link Flake8_Error      Error
highlight link Flake8_Warning    WarningMsg
highlight link Flake8_Complexity WarningMsg
highlight link Flake8_Naming     WarningMsg
highlight link Flake8_PyFlake    WarningMsg
"autocmd BufWritePost *.py call Flake8()


au BufReadPre,BufNewFile *.cpp,*.h,*.hpp,*.c,*.ipp setfiletype cpp
au BufReadPre,BufNewFile *.go setfiletype go
au BufReadPre,BufNewFile *.py setfiletype python

"" 定义函数AutoSetFileHead，自动插入文件头
"source ~/.cpp.vimrc
autocmd BufNewFile *.sh,*.py,*.go,*.cpp,*.php,*.h,*,hpp,*,ipp,*.c exec ":call AutoSetFileHead()"
function! AutoSetFileHead()
    "如果文件类型为.sh文件
    if &filetype == 'sh'
        call setline(1, "\#!/bin/bash")
        normal G
        normal o
    "如果文件类型为python
    elseif &filetype == 'python'
        call setline(1, "\#!/usr/bin/env python3")
        call setline(2, "\# -*- coding: utf-8 -*-")
        normal G
        normal o
    elseif &filetype == 'cpp'
        :
        "source ~/.cpp.vimrc
    elseif &filetype == 'go'
        source ~/.go.vimrc
    endif

endfunc

au BufReadPre *.cpp,*.h,*.hpp,*.c,*.ipp,*.go exec ":call SourceFile()"
function! SourceFile()
    if &filetype == 'cpp'
        :
        "source ~/.cpp.vimrc
    elseif &filetype == 'go'
        source ~/.go.vimrc
    endif
endfunc

"" F2 行号开关，用于鼠标复制代码用
"" 为方便复制，用<F2>开启/关闭行号显示:
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

au InsertLeave * set nopaste

set rnu
set number
set ffs=unix
"set mouse=a
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
set tabstop=4
set expandtab
autocmd FileType make set noexpandtab
set softtabstop=4
set autoindent
set smartindent
set cindent
set shiftwidth=4
set tags=tags;
set termencoding=utf-8
set encoding=utf-8
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936,big5,latin-1
set nohlsearch
set pastetoggle=<F5>

au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview

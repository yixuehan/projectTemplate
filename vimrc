set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')
"Plugin 'yixuehan/YouCompleteMe'
Plugin 'Valloric/YouCompleteMe'

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" 语法检查
Plugin 'scrooloose/syntastic'

" Bundle 'gmarik/Vundle.vim'
" Plugin 'tpope/vim-fugitive'
Plugin 'Shougo/neocomplete'
Plugin 'ervandew/supertab'
Plugin 'scrooloose/nerdtree'
Plugin 'majutsushi/tagbar'
Plugin 'fholgado/minibufexpl.vim'
Plugin 'vim-scripts/OmniCppComplete'
Plugin 'flazz/vim-colorschemes'
Plugin 'rking/ag.vim'  "https://geoff.greer.fm/ag/releases/the_silver_searcher-1.0.2.tar.gz
Plugin 'Valloric/ListToggle'
Plugin 'fatih/vim-go' " :GoInstallBinaries
Plugin 'python.vim'
Plugin 'nvie/vim-flake8'
Plugin 'tell-k/vim-autopep8'
Plugin 'nsf/gocode', {'rtp': 'vim/'}

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" F2 行号开关，用于鼠标复制代码用
" 为方便复制，用<F2>开启/关闭行号显示:
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

set pastetoggle=<F5>

let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_error_symbol = '>>'
let g:ycm_warning_symbol = '>*'
" 自动补全配置
set completeopt=longest,menu    "让Vim的补全菜单行为与一般IDE一致(参考VimTip1228)
autocmd InsertLeave * if pumvisible() == 0|pclose|endif    "离开插入模式后自动关闭预览窗口
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"    "回车即选中当前项
"上下左右键的行为 会显示其他信息
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"

"youcompleteme  默认tab  s-tab 和自动补全冲突
"let g:ycm_key_list_select_completion=['<c-n>']
"let g:ycm_key_list_select_completion = ['<Down>']
"let g:ycm_key_list_previous_completion=['<c-p>']
let g:ycm_key_list_previous_completion = ['<Up>']
let g:ycm_confirm_extra_conf=0 "关闭加载.ycm_extra_conf.py提示

let g:ycm_collect_identifiers_from_tags_files=1    " 开启 YCM 基于标签引擎
let g:ycm_min_num_of_chars_for_completion=1    " 从第2个键入字符就开始罗列匹配项
"let g:ycm_cache_omnifunc=0    " 禁止缓存匹配项,每次都重新生成匹配项
let g:ycm_seed_identifiers_with_syntax=1    " 语法关键字补全
let g:max_diagnostics_to_display=100
nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>    "force recomile with syntastic
"nnoremap <leader>lo :lopen<CR>    "open locationlist
"nnoremap <leader>lc :lclose<CR>    "close locationlist
let mapleader=","
inoremap <leader><leader> <C-x><C-o>
"在注释输入中也能补全
let g:ycm_complete_in_comments = 1
"在字符串输入中也能补全
let g:ycm_complete_in_strings = 1
"注释和字符串中的文字也会被收入补全
let g:ycm_collect_identifiers_from_comments_and_strings = 0

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

let g:go_fmt_fail_silently = 1
" format with goimports instead of gofmt
let g:go_fmt_command = "goimports"
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go', 'java'] }

let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

let g:syntastic_error_symbol='>>'
let g:syntastic_warning_symbol='>'
let g:syntastic_check_on_open=1
let g:syntastic_check_on_wq=0
let g:syntastic_enable_highlighting=1

" checkers
" python
" pip install flake8
let g:syntastic_python_checkers=['flake8', ] " 使用pyflakes,速度比pylint快
let g:syntastic_python_flake8_options='--ignore=E501,E225,E124,E712,E116,E131'

" javascript
" let g:syntastic_javascript_checkers = ['jsl', 'jshint']
" let g:syntastic_html_checkers=['tidy', 'jshint']
" npm install -g eslint eslint-plugin-standard eslint-plugin-promise eslint-config-standard
" npm install -g eslint-plugin-import eslint-plugin-node eslint-plugin-html babel-eslint
let g:syntastic_javascript_checkers = ['eslint']

" to see error location list
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_enable_signs = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_auto_jump = 0
let g:syntastic_loc_list_height = 5
let g:syntastic_mode_map = {'mode': 'active', 'passive_filetypes': ['java'] }

nnoremap <leader>] :YcmCompleter GoToDefinitionElseDeclaration<CR> " 跳转到定义处



au BufEnter /usr/include/c++/7/*     setf cpp
au BufEnter /usr/include/*     setf cpp


"自动添加文件头
autocmd BufNewFile *.sh,*.py exec ":call AutoSetFileHead()"
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


let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview

"--------------------------------------------------------------------------------
"tagbar
"nnoremap <silent> <F11> :TagbarToggle<CR>
let g:tagbar_autoclose = 0
let g:tagbar_sort = 0
let g:tagbar_indent = 1
"let g:tagbar_iconchars = ['+', '-']
let g:tagbar_left = 1
let g:tagbar_width = 42
let g:tagbar_compact = 1

"------------------------------------------------------------
"nerdtree
autocmd WinEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let NERDTreeWinSize = 82
let NERDTreeWinPos = "right"
let NERDTreeShowHidden = 1
let NERDTreeAutoCenter = 1
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeDirArrowExpandable = '+'
let NERDTreeDirArrowCollapsible = '-'
let NERDTreeRespectWildIgnore = 1
let NERDTreeQuitOnOpen = 1

"------------------------------------------------------------
"minbufexplorer

"------------------------------------------------------------
"ag.vim
let g:ag_prg = "ag --cpp --cc --vimgrep"
let g:ag_working_path_mode = "r"
let g:ag_highlight = 1
let g:ag_qhandler="copen 20"
let g:ag_mapping_message = 0
let g:ag_apply_qmappings = 1

let g:lt_height = 20

"------------------------------------------------------------
"go.vim
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

"let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1
let g:go_fmt_autosave = 0
let g:go_play_open_browser = 0
let g:go_get_update = 0

let g:neocomplete#enable_at_startup = 1

autocmd BufWritePre *.go GoFmt
"autocmd BufWritePre *.go GoErrCheck

"-------------------------------------------------------------
"Flake8
let g:flake8_quickfix_height = 7
highlight link Flake8_Error      Error
highlight link Flake8_Warning    WarningMsg
highlight link Flake8_Complexity WarningMsg
highlight link Flake8_Naming     WarningMsg
highlight link Flake8_PyFlake    WarningMsg
autocmd BufWritePost *.py call Flake8()


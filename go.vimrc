source ${HOME}/projectTemplate/base.vimrc
set nocompatible

filetype off 

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'SirVer/ultisnips'
Plugin 'scrooloose/nerdtree'
Plugin 'majutsushi/tagbar'
Plugin 'Raimondi/delimitMate'
Plugin 'nvie/vim-flake8'
Plugin 'dgryski/vim-godef'   
"Plugin 'Blackrush/vim-gocode'
Plugin 'nsf/gocode', {'rtp': 'vim/'}
Plugin 'fatih/vim-go',{'do':':GoInstallBinaries'}
Plugin 'scrooloose/syntastic'

"Plugin 'Shougo/neocomplete'  
"Plugin 'zchee/deoplete-go'   
call vundle#end()

filetype plugin indent on

let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_error_symbol = '>>'
let g:ycm_warning_symbol = '>*'
let g:ycm_auto_trigger = 1
let g:ycm_max_num_candidates  =  0
let g:ycm_max_num_identifier_candidates  =  0
let g:ycm_always_populate_location_list  =  1
let g:ycm_collect_identifiers_from_tags_files  =  1
let g:ycm_seed_identifiers_with_syntax  =  1
let g:ycm_disable_for_files_larger_than_kb  =  0
let g:ycm_use_ultisnips_completer = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1   "注释和字符串中的文字也会被收入补全
let g:ycm_collect_identifiers_from_tags_files = 1"
let g:ycm_log_level='debug'

let g:ycm_add_preview_to_completeopt = 0
let g:ycm_show_diagnostics_ui = 1
let g:ycm_server_log_level = 'info'
let g:ycm_min_num_identifier_candidate_chars = 2
let g:ycm_min_num_of_chars_for_completion = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_strings=1
let g:ycm_key_invoke_completion = '<c-z>'
"set completeopt=menu,menuone

noremap <c-z> <NOP>

let g:ycm_semantic_triggers =  {
			\ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
			\ 'cs,lua,javascript': ['re!\w{2}'],
			\ }

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
"let g:ycm_cache_omnifunc=0    " 禁止缓存匹配项,每次都重新生成匹配项
let g:ycm_seed_identifiers_with_syntax=1    " 语法关键字补全
let g:max_diagnostics_to_display=1000
nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>    "force recomile with syntastic
"nnoremap <leader>lo :lopen<CR>    "open locationlist
"nnoremap <leader>lc :lclose<CR>    "close locationlist
let mapleader=","

let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go', 'java'] }

let g:syntastic_error_symbol='>>'
let g:syntastic_warning_symbol='>*'
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

nnoremap <leader>] :YcmCompleter GoToDefinitionElseDeclaration<CR> " 跳转到定义处



au BufEnter /usr/include/c++/7/*     setf cpp
au BufEnter /usr/include/*     setf cpp

let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
"automatically open and close the popup menu / preview window
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

"-------------------------------------------------------------
"Flake8
let g:flake8_quickfix_height = 7
highlight link Flake8_Error      Error
highlight link Flake8_Warning    WarningMsg
highlight link Flake8_Complexity WarningMsg
highlight link Flake8_Naming     WarningMsg
highlight link Flake8_PyFlake    WarningMsg
autocmd BufWritePost *.py call Flake8()



"插入模式下直接通过<C-z>键来触发UltiSnips的代码块补全

let g:UltiSnipsExpandTrigger="<C-z>"

"弹出UltiSnips的可用列表,由于不常用, 所以这里设置成了特殊的<C-i>映射

let g:UltiSnipsListSnippets="<C-i>"

"<C-f>跳转的到下一个代码块可编辑区

let g:UltiSnipsJumpForwardTrigger="<C-f>"

"<C-b>跳转到上一个代码块可编辑区

let g:UltiSnipsJumpBackwardTrigger="<C-b>"


" 设置NerdTree

map <F7> :NERDTreeMirror<CR>

map <F7> :NERDTreeToggle<CR>

"tagbar
"F9触发，设置宽度为30

let g:tagbar_width = 30

nmap <F9> :TagbarToggle<CR>

"开启自动预览(随着光标在标签上的移动，顶部会出现一个实时的预览窗口)

"let g:tagbar_autopreview = 1

"关闭排序,即按标签本身在文件中的位置排序

let g:tagbar_sort = 0

"go.vim
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1
let g:go_fmt_autosave = 0
let g:go_play_open_browser = 0
let g:go_get_update = 0

let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go', 'java'] }
"
let g:neocomplete#enable_at_startup = 1

autocmd BufWritePre *.go GoFmt
"autocmd BufWritePre *.go GoLint
"autocmd BufWritePre *.go GoErrCheck


" YCM settings

imap <F6> <C-x><C-o>

" dependence
" 1. shellcheck `brew install shellcheck` https://github.com/koalaman/shellcheck

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

function! ToggleErrors()
    let old_last_winnr = winnr('$')
    lclose
    if old_last_winnr == winnr('$')
        " Nothing was closed, open syntastic_error location panel
        Errors
    endif
endfunction
nnoremap <Leader>s :call ToggleErrors()<cr>

" ,en ,ep to jump between errors
function! <SID>LocationPrevious()
try
    lprev
catch /^Vim\%((\a\+)\)\=:E553/
    llast
endtry
endfunction

function! <SID>LocationNext()
try
    lnext
catch /^Vim\%((\a\+)\)\=:E553/
    lfirst
endtry
endfunction


" 修改高亮的背景色, 适应主题
highlight SyntasticErrorSign guifg=white guibg=black

" 禁止插件检查java
" thanks to @marsqing, see https://github.com/wklken/k-vim/issues/164
let g:syntastic_mode_map = {'mode': 'active', 'passive_filetypes': ['java'] }

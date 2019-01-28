set nocompatible

filetype off

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'fatih/vim-go'
Plugin 'honza/vim-snippets'
Plugin 'Shougo/neocomplete'
Plugin 'zchee/deoplete-go'

Plugin 'SirVer/ultisnips'
Plugin 'scrooloose/nerdtree'
Plugin 'majutsushi/tagbar'
Plugin 'Raimondi/delimitMate'

call vundle#end()

filetype plugin indent on

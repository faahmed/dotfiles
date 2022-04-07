" List of dotfiles:
" .vimrc
" .bashrc
" /etc/inputrc
" .tmux.conf
" My terminal theme is Dark Pastel from https://github.com/lysyi3m/macos-terminal-themes
" background=dark needs to be set for the colors to show up as intended
set background=dark
set nocompatible              " be iMproved, required
set re=2
filetype off                  " required


" disable the super annoying bell
set visualbell
set t_vb=

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Plugin for kotlin support
Plugin 'udalov/kotlin-vim'
" Keep Plugin commands between vundle#begin/end.

Plugin 'easymotion/vim-easymotion'

" plugin on GitHub repo
" Git plugin not hosted on GitHub
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

syntax on
" Maps insert mode double-i into Escape key
"if v:version > 703 || v:version == 703 && has("patch1261")
"	inoremap <nowait> ii <Esc>
"else
inoremap ii <Esc>
"endif
set shiftwidth=4
set smartindent
set tabstop=4
set expandtab
set softtabstop=0
vnoremap ii <Esc> 
set number
set ruler
set ignorecase
set virtualedit=block
"set cursorline
"set cursorcolumn
set hlsearch
" SpaceBar= EasyMotion to any word currently visible on screen
map <Space> H<Plug>(easymotion-prefix)w
map \ <Plug>(easymotion-prefix)
" in visual modes, Y to yank to windows clipboard
" xnoremap Y <esc>:'<,'>:w !clip.exe<CR><CR>
map <F3> :%s/\s\+//g<CR>
"command Se :%s/\s\+//g<CR>

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
"C:\Program Files (x86)\Vim\bundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Make sure you use single quotes

"Plugins for interface
Plugin 'jiangmiao/auto-pairs'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'vim-airline/vim-airline'
Plugin 'ryanoasis/vim-devicons'
Plugin 'dracula/vim', { 'name': 'dracula' }
Plugin 'morhetz/gruvbox'
Plugin 'preservim/nerdtree'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'valloric/youcompleteme'
Plugin 'searleser97/cpbooster.vim'
Plugin 'tpope/vim-dispatch.git'
Plugin 'gabrielsimoes/cfparser.vim'
Plugin 'voldikss/vim-floaterm'
Plugin 'tomtom/tcomment_vim'
Plugin 'mh21/errormarker.vim'
Plugin 'kassio/neoterm'

call vundle#end()

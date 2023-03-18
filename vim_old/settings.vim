"Remap the leader keys
let g:mapleader="\<Space>"
let g:maplocalleader="\<Space>"

set nocompatible              " be iMproved, required
filetype off                  " required

au VimEnter * if !&diff | tab all | tabfirst | endif
au GUIEnter * simalt ~x
autocmd GUIEnter * set visualbell t_vb=
"au BufAdd,BufNewFile * nested tab sball
autocmd VimEnter * set bufhidden=hide
autocmd VimEnter * set vb t_vb=
"autocmd VimEnter * startinsert
"autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
autocmd BufEnter * silent! lcd %:p:h


"set autochdir
set hls
set t_vb=
set is
set cb=unnamed
set ts=2
set sw=2
set number
set ruler
set showcmd
set showmatch
set mouse=a
set relativenumber
set backspace=indent,eol,start
set splitright splitbelow
set title
set laststatus=3
set noshowmode
set encoding=utf-8
set conceallevel=2
set cursorline
set noerrorbells visualbell t_vb=
set belloff=all
set showtabline=2
set splitright splitbelow
set hidden
set noswapfile
set wildmenu
set lazyredraw
set updatetime=200
set ttimeoutlen=50
set wak=no
set clipboard=unnamedplus
syntax enable
filetype plugin indent on
let g:neoterm_autoinsert=1
"Append template to new C++ files
autocmd BufNewFile *.cpp 0r .template/template.cpp
" Let clangd fully control code completion
" let g:ycm_clangd_uses_ycmd_caching = 0
" Use installed clangd, not YCM-bundled clangd which doesn't get updates.
" let g:ycm_clangd_binary_path = exepath("clangd")
" let g:ycm_global_ycm_extra_conf = '~/Setup_CP/.ycm_extra_conf.py'
" let g:ycm_clangd_args = ['-log=verbose', '-pretty']
"" Makes bash open in the working directory
let $CHERE_INVOKING=1
"clang-format
map <C-K> :py3f /usr/share/clang/clang-format-14/clang-format.py<cr>
imap <C-K> <c-o>:py3f /usr/share/clang/clang-format-14/clang-format.py<cr>
function! Formatonsave()
	let l:formatdiff = 1
	py3f /usr/share/clang/clang-format-14/clang-format.py
endfunction
autocmd BufWritePre *.h,*.cc,*.cpp call Formatonsave()

 
"Clipboard configuration
let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
if executable(s:clip)
        augroup WSLYank
                    autocmd!
                            autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
                                augroup END
                            endif
 
        au BufNewFile,BufRead *.tex
            \ set nocursorline |
            \ set nornu |
            \ set number |
            \ let g:loaded_matchparen=1 |

let &errorformat="%f:%l:%c: %t%*[^:]:%m,%f:%l: %t%*[^:]:%m," . &errorformat

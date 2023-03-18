"text font (better use Nerd font to support devicons)
if has("gui_running")
	set guifont=DejaVuSansMono_Nerd_Font_Mono:h9
else
	set guifont=DejaVuSansMono_Nerd_Font_Mono:h12
endif

"active color pair
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
"theme
" set background=light
colorscheme dracula
let g:airline_theme='dracula'

"----- Customize for vim-airlines -----"
"enable tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'default'
"let g:airline#extensions#tabline#left_sep = ''
"let g:airline#extensions#tabline#left_alt_sep = ''
"let g:airline#extensions#tabline#right_sep = ''
"let g:airline#extensions#tabline#right_alt_sep = ''

" enable powerline fonts
let g:airline_powerline_fonts = 1
"let g:airline_left_sep = ''
"let g:airline_right_sep = ''

if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif

"setting for color terminal
if !has("gui_running")
	set termguicolors
	"set t_Co=256
endif
"let NVIM_TUI_ENABLE_CURSOR_SHAPE =1
highlight Cursor guifg=white guibg=red
highlight iCursor guifg=white guibg=green
set guicursor=n-v:block-Cursor
set guicursor+=i-c:ver10-iCursor
set guicursor+=n-v-c-i:blinkon0
"let g:formatterpath = ['']
if &term =~ "xterm\\|rxvt"
  " use an orange cursor in insert mode
  let &t_SI = "\<Esc>]12;green\x7"
  " use a red cursor otherwise
  let &t_EI = "\<Esc>]12;red\x7"
  silent !echo -ne "\033]12;red\007"
  " reset cursor when vim exits
  autocmd VimLeave * silent !echo -ne "\033]112\007"
  " use \003]12;gray\007 for gnome-terminal and rxvt up to version 9.21
endif


" Set floaterm window's background to black
"hi Floaterm guibg=black
" Set floating window border line color to cyan, and background to orange
hi FloatermBorder guibg=orange guifg=cyan

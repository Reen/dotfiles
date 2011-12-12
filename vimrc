if exists("*pathogen#helptags")
	filetype off
	call pathogen#helptags()
	call pathogen#runtime_append_all_bundles()
endif
filetype plugin indent on

set nocompatible

" Security
"set modelines=0

" Tabs/spaces
set tabstop=4
set shiftwidth=4
set softtabstop=4
"set expandtab

" Basic options
set encoding=utf-8
set scrolloff=4
set autoindent
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
"set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
"set relativenumber
set number
set laststatus=2
"set undofile
set title
set history=1000

" Leader and mappings for leader
let mapleader = ","
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr> " edit vim config

" Easy buffer navigation
map <C-h> <C-w>h " switches to buffer left of current
map <C-j> <C-w>j " switches to buffer above of current
map <C-k> <C-w>k " switches to buffer below of current
map <C-l> <C-w>l " switches to buffer right of current
map <leader>w <C-w>v<C-w>l " split window vertically

" Searching
nnoremap / /\v
vnoremap / /\v
set ignorecase 
set smartcase
set incsearch " ...dynamically as they are typed.
set showmatch
set hlsearch
set gdefault
map <leader><space> :let @/=''<cr> " reset search
runtime macros/matchit.vim
nmap <tab> %
vmap <tab> %

" Soft/hard wrapping
set nowrap
"set textwidth=79
"set formatoptions=qrn1
if exists("&colorcolumn")
	set colorcolumn=85
endif

" Use the same symbols as TextMate for tabstops and EOLs
set list

" Color scheme (terminal)
syntax on
"set background=dark
colorscheme fruidle

" Use Pathogen to load bundles
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

"nmap <silent> <leader>n :silent :nohlsearch<CR>
set listchars=tab:>-,trail:·,eol:$
"nmap <silent> <leader>s :set nolist!<CR>

"set ofu=syntaxcomplete#Complete

if has('gui_running')
	set listchars=tab:▸\ ,eol:¬
	if exists("&fuoptions")
		set fuoptions=maxvert,maxhorz
	endif
	" Fuck you, help key.
	inoremap <F1> <ESC>
	nnoremap <F1> <ESC>
	vnoremap <F1> <ESC>
endif

" Clean whitespace
map <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" Formatting, TextMate-style
map <leader>q gqip

nmap <leader>m :make<cr>


" """""""""""""""""""""""""""""""""""""""""
" Plugin related
" """""""""""""""""""""""""""""""""""""""""

" NERD Tree
map <F2> :NERDTreeToggle<cr>
let NERDTreeIgnore=['\~$', '.*\.pyc$', 'pip-log\.txt$']
let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=2

" Exuberant ctags!
if filereadable("/sw/bin/ctags")
	let Tlist_Ctags_Cmd = "/sw/bin/ctags"
endif
let Tlist_WinWidth = 50
let Tlist_Use_Right_Window = 1
let Tlist_Compact_Format = 1
"let Tlist_Display_Prototype = 1
let Tlist_Close_On_Select = 1
let tlist_php_settings = 'php;c:class;f:function'
map <F4> :TlistOpen<cr>
map <F5> :!/sw/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --exclude='@.ctagsignore' .<cr>

" Yankring
nnoremap <silent> <F3> :YRShow<cr>
nnoremap <silent> <leader>y :YRShow<cr>

" LustyJuggler
let g:LustyJugglerSuppressRubyWarning = 1

" Ack
nnoremap <leader>a :Ack

" YankRing
let g:yankring_min_element_length = 2
"let g:yankring_history_dir = '$VIM'

map fc <Esc>:call CleanClose(1)<CR>
map fq <Esc>:call CleanClose(0)<CR>

function! CleanClose(tosave)
	if (a:tosave == 1)
		w!
	endif
	let todelbufNr = bufnr("%")
	let newbufNr = bufnr("#")
	if ((newbufNr != -1) && (newbufNr != todelbufNr) && buflisted(newbufNr))
		exe "b".newbufNr
	else
		bnext
	endif

	if (bufnr("%") == todelbufNr)
		new
	endif
	exe "bw".todelbufNr
endfunction

function! FormatFortran()
	set filetype=fortran
	retab
	:%s/\s\+$//
endfunction

nmap <silent> <leader>f :call FormatFortran()<CR>
set printoptions=paper:A4,syntax:y,wrap:y,number:y

" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
   let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d :",
         \ &tabstop, &shiftwidth, &textwidth)
   let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
   call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

" allow loading of project specific .vimrc
set exrc
set secure
autocmd VimEnter * NERDTree

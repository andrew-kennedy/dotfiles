filetype plugin indent on

" stop trying to be compatible with vi
set nocompatible

" disable modelines because of a security vuln
set modelines=0

" how wide a tab is
set tabstop=4

" number of spaces to use for shiftwidth (<< or >>) operator
set shiftwidth=4

" number of spaces that a tab counts for while performing
" an editing operation, like inserting a tab or backspace
set softtabstop=4

" insert spaces when tab is pressed
set expandtab

set encoding=utf-8

" lines to keep above or below the cursor in window
set scrolloff=3

" when inserting a new line, copy indent from previous line 
set autoindent

" If in Insert, Replace or Visual mode put a message on the last line.
set showmode

" Show (partial) command in the last line of the screen.
set showcmd

" abandoned buffers become hidden instead of unloaded
set hidden

set wildmenu
set wildmode=list:longest

" Use visual bell instead of beeping.
set visualbell

" highlight the line with the cursor
set cursorline

" let vim know we have a fast tty
set ttyfast

" Show the line and column number of the cursor position
set ruler
" To allow backspacing over everything in insert mode 
" (including automatically inserted indentation, line breaks and start of insert)
set backspace=indent,eol,start

" last window always has a status line
set laststatus=2

" enable relative line numbers
set relativenumber

" track undo information in files located in undodir
set undofile


let mapleader=","

nnoremap / /\v
vnoremap / /\v

" If the 'ignorecase' option is on, the case of normal letters is ignored.
set ignorecase
" Override the 'ignorecase' option if the search pattern contains uppercase characters.
set smartcase
" replace all occurrences in line by default
set gdefault

" better searching 
set incsearch
set showmatch
set hlsearch
" turn off highlighting via key combo
nnoremap <leader><space> :noh<cr>

" easier way to tab between brackets
nnoremap <tab> %
vnoremap <tab> %

" handle long lines correctly
set wrap
set textwidth=79
set formatoptions=qrn1
set colorcolumn=85

" make it easier to get to command mode
nnoremap ; :

" save on focus lost
au FocusLost * :wa

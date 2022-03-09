" https://github.com/junegunn/vim-plug
command PlugGet execute '!curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

call plug#begin(stdpath('data') . '/plugged')
Plug 'morhetz/gruvbox'

Plug 'akinsho/bufferline.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'ziglang/zig.vim'
call plug#end()

" leader key
let mapleader = "\<Space>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
" Enable completions as you type
let g:completion_enable_auto_popup = 1

lua <<EOF
    require('bufferline').setup{}

    require('indent_blankline').setup {
        char = "|",
        buftype_exclude = {"terminal"}
    }
EOF

" open this file
nnoremap <leader>rc :e $MYVIMRC<CR>

" colors and font
colorscheme gruvbox
set termguicolors

" split navigation
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
inoremap <C-j> <ESC><C-w>j
inoremap <C-k> <ESC><C-w>k
inoremap <C-l> <ESC><C-w>l
inoremap <C-h> <ESC><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l
tnoremap <C-h> <C-\><C-n><C-w>h
set splitbelow
set splitright

" buffer navigation
set hidden
noremap <leader>, :bprev<CR>
noremap <leader>. :bnext<CR>
nnoremap <leader>b :buffers<CR>:b

" safer <C-u> and <C-w>
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" disables automatic commenting on newline
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" change to the dir of currently open file
noremap <leader>cd :cd %:p:h<CR>:pwd<CR>

" basics
syntax enable
filetype plugin indent on
set backspace=indent,eol,start
set mouse=a
set number

" line breaking
set wrap

" searching
set ignorecase
set smartcase
set incsearch 
" clear search highlightning
nnoremap <silent> <ESC> :noh<CR><ESC>

" show matching brackets for tenths of second
set showmatch 
set mat=2

" tabs and indentation
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set autoindent

" system clipboard
noremap <leader>y "+y
noremap <leader>Y "+Y
noremap <leader>p "+p
noremap <leader>P "+P
noremap <leader>d "+d
noremap <leader>D "+D

" automatic reload if file changed
set autoread
autocmd FocusGained,BufEnter * :silent! !

" better increasing/decreasing with <C-a>/<C-x>
set nrformats-=octal

" disable annoying defaults
nnoremap ZZ <ESC>

" integrated terminal
tnoremap <Esc> <C-\><C-n>
autocmd BufEnter term://* startinsert

" quick access
nnoremap <leader>w :w<CR>
nnoremap <leader>; :

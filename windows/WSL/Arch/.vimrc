" ========================================
" Options
" ========================================

set encoding=UTF-8
set spelllang=en_us,de_de,es_es
set nohlsearch
set number
set mouse=a
set breakindent
set undofile
set ignorecase
set smartcase
set signcolumn=yes
set updatetime=250
set timeoutlen=300
set nobackup
set nowritebackup
set completeopt=menuone,noselect
set whichwrap+=<,>,[,],h,l
set nowrap
set linebreak
set scrolloff=8
set sidescrolloff=8
set relativenumber
set numberwidth=4
set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab
set nocursorline
set splitbelow
set splitright
set noswapfile
set smartindent
set showtabline=2
set backspace=indent,eol,start
set pumheight=10
set conceallevel=0
set fileencoding=utf-8
set cmdheight=1
set autoindent
set shortmess+=c
set iskeyword+=-
set showmatch
set laststatus=2
set statusline=%f%=%l/%L

" ========================================
" Keymaps
" ========================================

let mapleader = " "
let maplocalleader = " "

nnoremap <Space> <Nop>
vnoremap <Space> <Nop>

nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <Esc> :noh<CR>
nnoremap <C-s> :w<CR>
nnoremap <leader>sn :noautocmd w<CR>
nnoremap <C-q> :q<CR>
nnoremap x "_x
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <Up> :resize -2<CR>
nnoremap <Down> :resize +2<CR>
nnoremap <Left> :vertical resize -2<CR>
nnoremap <Right> :vertical resize +2<CR>
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>
nnoremap <leader>sb :buffers<CR>:buffer<Space>
nnoremap <leader>+ <C-a>
nnoremap <leader>- <C-x>
nnoremap <leader>v <C-w>v
nnoremap <leader>h <C-w>s
nnoremap <leader>se <C-w>=
nnoremap <leader>xs :close<CR>
nnoremap <C-k> :wincmd k<CR>
nnoremap <C-j> :wincmd j<CR>
nnoremap <C-h> :wincmd h<CR>
nnoremap <C-l> :wincmd l<CR>
nnoremap <leader>to :tabnew<CR>
nnoremap <leader>tx :tabclose<CR>
nnoremap <leader>tn :tabn<CR>
nnoremap <leader>tp :tabp<CR>
nnoremap <leader>x :bdelete<CR>
nnoremap <leader>b :enew<CR>
nnoremap <leader>lw :set wrap!<CR>
inoremap jk <ESC>
inoremap kj <ESC>
vnoremap p "_dP
noremap <leader>y "+y
noremap <leader>Y "+Y
noremap <silent> <leader>e :Lex<CR>

" ========================================
" Other
" ========================================

syntax on
colorscheme evening
set background=dark

" Clipboard sync for Arch WSL (requires xclip or wl-clipboard with a display server like VcXsrv)
if executable("xclip") || executable("wl-copy")
  set clipboard=unnamedplus
endif

" Enable true color support
if !has('gui_running') && &term =~ '\%(screen\|tmux\|xterm\|linux\)'
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
set termguicolors

" Line cursor in insert mode and block elsewhere
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" Netrw config
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25
augroup netrw_setup | au!
  au FileType netrw nmap <buffer> l <CR>
augroup END

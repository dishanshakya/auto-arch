set number relativenumber
syntax on
filetype plugin indent on
set mouse=a
set switchbuf=useopen,usetab,newtab

set tabstop=2
set shiftwidth=2
set laststatus=2

call plug#begin('~/.vim/plugged')

" File Explorer & FZF
Plug 'preservim/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'github/copilot.vim'

Plug 'sonph/onehalf', { 'rtp': 'vim' }

call plug#end()

" --- Essential Vim settings for Syntax & Indentation ---
" Enable syntax highlighting
syntax on

" Enable filetype detection, plugins, and indentation
filetype plugin indent on

" Show matching brackets
set showmatch

if has('termguicolors')
  set termguicolors
endif

" Indentation settings (vim-sleuth will override these per-project)
set expandtab           " Use spaces instead of tabs
set softtabstop=2       " Tab key inserts 2 spaces
set autoindent          " Copy indent from current line when starting a new line
set smartindent         " Automatically inserts indentation after {, }, etc.

set background=dark
colorscheme onehalfdark

let g:nerdtree_tabs_autofind = 1
let g:nerdtree_tabs_open_on_console_startup = 0
let g:nerdtree_tabs_open_on_gui_startup = 0

let g:vim_jsx_pretty_colorful_config = 1 " default 0
" Force JSX highlighting in .js files
let g:vim_jsx_pretty_enable_jsx_highlight = 1

let g:fzf_action = {
  \ 'ctrl-o': '',
  \ 'enter': 'tab split' }


let g:jsx_ext_required = 0

nnoremap mm :NERDTreeTabsToggle<CR>
nnoremap M :Files<CR>
nnoremap ? :Rg<CR>
nnoremap B :Buffers<CR>

" Function to toggle between two windows
function! ToggleLeftRight()
    " If we are in the leftmost window, go right; else go left
    if winnr() == 1
        wincmd l
    else
        wincmd h
    endif
endfunction

" Map ff to toggle
nnoremap ff :call ToggleLeftRight()<CR>

nnoremap w gT
nnoremap ; gt

nnoremap QQ :wqa<CR>
nnoremap <Space><Space> :tabc<CR>

nnoremap L $
nnoremap H ^
nnoremap Y "+yy
vnoremap Y "+y



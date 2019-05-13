"General
" required:
set nocompatible
" required:
" filetype off
set autoindent
set hlsearch
set rnu nu
let mapleader = ','

"split navigations
set splitbelow
set splitright

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Autoclose braces
inoremap " ""<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable folding with the spacebar
nnoremap <space> za

let python_highlight_all=1
filetype plugin indent on
syntax on

"python with virtualenv support
py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF
set encoding=utf-8

" Automatically save the file notes when idle
autocmd CursorHold .notes :write

" Apply macros with Q
nnoremap Q @q
vnoremap Q :norm @q<cr>

" Setup netrw

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 20
"augroup ProjectDrawer
"  autocmd!
"  autocmd VimEnter * :Vexplore
"augroup END

" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

" Buffer behavior
set hidden
nnoremap <BS> <C-^>
nnoremap <Leader>b :ls<CR>:b<Space>

let &t_SI = "\<esc>[5 q"
let &t_SR = "\<esc>[4 q"
let &t_EI = "\<esc>[2 q"
autocmd VimLeave * let &t_me="\<esc>[4 q"


" Config vimtex
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'

" Config UltiSnips
let g:UltiSnipsSnippetDirectories = ['/home/ben/.vim/UltiSnips', '/home/ben/.vim/my-snippets/']
let g:UltiSnipsExpandTrigger = '<C-x>'
let g:UltiSnipsJumpForwardTrigger = '<C-b>'
let g:UltiSnipsJumpBackwardTrigger = '<C-z>'

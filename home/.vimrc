set nocompatible

set nobackup
set nowritebackup
set nowrap
set ruler
set showcmd
set showmatch
set showmode

set autoindent
set expandtab
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2

set fileformat=unix    " If not unix formatted, I want to know
set ignorecase         " Ignore case in searches...
set hlsearch           " Highlight search results
set showmatch          " Highlight matching character briefly

set nolist
set noeb vb t_vb=

syntax enable

nmap ts :%s/\s\+$//<CR>
nmap tn :tabnew<space>
nmap <D-k> :tabn<CR>
nmap <D-j> :tabp<CR>


":%s/\s\+$// "remove trailing spaces

set background=dark
"set guifont = lucinda_console
"set guifont = Menlo
"colorscheme evening
"colorscheme solarized
colorscheme phylite

"colorscheme solarized



call plug#begin('~/.vim/plugged')
Plug 'kballard/vim-swift'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-sensible'
Plug 'altercation/vim-colors-solarized'
Plug 'bling/vim-airline'
"Plug 'scrooloose/syntastic' "{{{
"  set statusline+=%#warningmsg#
"  set statusline+=%{SyntasticStatuslineFlag()}
"  set statusline+=%*
"  let g:syntastic_always_populate_loc_list = 1
"  let g:syntastic_auto_loc_list = 1
"  let g:syntastic_check_on_open = 1
"  let g:syntastic_check_on_wq = 0
"}}}
Plug 'tpope/vim-fugitive' "{{{
  nnoremap <silent> <leader>gs :Gstatus<CR>
  nnoremap <silent> <leader>gd :Gdiff<CR>
  nnoremap <silent> <leader>gc :Gcommit<CR>
  nnoremap <silent> <leader>gb :Gblame<CR>
  nnoremap <silent> <leader>gl :Glog<CR>
  nnoremap <silent> <leader>gp :Git push<CR>
  nnoremap <silent> <leader>gw :Gwrite<CR>
  nnoremap <silent> <leader>gr :Gremove<CR>
  autocmd FileType gitcommit nmap <buffer> U :Git checkout -- <C-r><C-g><CR>
  autocmd BufReadPost fugitive://* set bufhidden=delete
"}}}
Plug 'vim-scripts/scons.vim' "{{{
  au BufNewFile,BufRead SCons* set filetype=scons
"}}}
call plug#end()


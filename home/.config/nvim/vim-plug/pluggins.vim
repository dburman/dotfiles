call plug#begin('~/.config/nvim/autoload/plugged')


	Plug 'preservim/nerdtree'
	Plug 'francoiscabrol/ranger.vim'
	Plug 'liuchengxu/vim-which-key'
	Plug 'nvim-telescope/telescope.nvim'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'rbgrouleff/bclose.vim'
	
	Plug 'rust-lang/rust.vim'
	Plug 'tpope/vim-sensible'
	Plug 'altercation/vim-colors-solarized'
	Plug 'bling/vim-airline'


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

call plug#end()

" Plugins install to nvim's data dir (~/.local/share/nvim/plugged), not inside
" ~/.config/nvim, so sync2git.sh can't sweep them into this repo.
call plug#begin(stdpath('data') . '/plugged')

	Plug 'preservim/nerdtree'
	Plug 'francoiscabrol/ranger.vim'
	Plug 'rbgrouleff/bclose.vim'          " required by ranger.vim on neovim
	Plug 'liuchengxu/vim-which-key'
	Plug 'nvim-lua/plenary.nvim'          " required by telescope
	Plug 'nvim-telescope/telescope.nvim'

	Plug 'rust-lang/rust.vim'
	Plug 'vim-airline/vim-airline'

	Plug 'tpope/vim-fugitive' "{{{
	" :Gstatus, :Gcommit, :Gblame, :Glog and :Gremove were removed from
	" fugitive; these are their current equivalents.
	nnoremap <silent> <leader>gs :Git<CR>
	nnoremap <silent> <leader>gd :Gdiffsplit<CR>
	nnoremap <silent> <leader>gc :Git commit<CR>
	nnoremap <silent> <leader>gb :Git blame<CR>
	nnoremap <silent> <leader>gl :Gclog<CR>
	nnoremap <silent> <leader>gp :Git push<CR>
	nnoremap <silent> <leader>gw :Gwrite<CR>
	nnoremap <silent> <leader>gr :GRemove<CR>
	augroup fugitive_custom
		autocmd!
		autocmd BufReadPost fugitive://* set bufhidden=delete
	augroup END
	"}}}

call plug#end()

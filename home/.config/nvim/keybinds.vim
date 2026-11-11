" Leader is Space (set in init.vim). Tapping it alone and pausing shows WhichKey.
nnoremap <silent> <leader> <cmd>WhichKey '<Space>'<cr>

nnoremap <leader>r <cmd>Ranger<cr>
nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>t <cmd>NERDTree<cr>
nnoremap <leader>k <cmd>tabn<cr>
nnoremap <leader>j <cmd>tabp<cr>

" Strip trailing whitespace / open a new tab. These used to be bare `ts` and
" `tn`, which hijacked the built-in `t{char}` motion (jump to before the next s
" or n) and made every `t` wait out timeoutlen. Not <leader>ts/tn either: that
" would make <leader>t (NERDTree) pause before firing.
nnoremap <leader>w :%s/\s\+$//e<cr>
nnoremap <leader>n :tabnew<space>

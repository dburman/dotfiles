" Space as leader. Must be set before any <leader> mapping is defined, which
" includes the fugitive mappings in pluggins.vim, so it stays at the very top.
let mapleader = " "

source ~/.config/nvim/vim-plug/pluggins.vim
source ~/.config/nvim/keybinds.vim

set timeoutlen=250

" ---- Clipboard ----------------------------------------------------------
" Every yank/delete/put goes through the system clipboard. On macOS that's
" pbcopy/pbpaste; on a Linux desktop it needs wl-clipboard or xclip installed.
set clipboard+=unnamedplus

" Over SSH no clipboard tool can reach your local machine, so copy with OSC 52:
" nvim sends the text as an escape sequence and the terminal (Ghostty) puts it
" on your local clipboard. Paste deliberately does NOT use OSC 52: reading the
" clipboard that way makes Ghostty show a permission prompt and nvim stalls
" waiting for it. Instead `p` pastes nvim's own last yank, and to paste from
" your local machine into a remote nvim use Cmd+V (the terminal types it in).
if !empty($SSH_TTY)
lua << EOF
  local osc52 = require('vim.ui.clipboard.osc52')
  local function paste()
    return { vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('') }
  end
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = { ['+'] = osc52.copy('+'), ['*'] = osc52.copy('*') },
    paste = { ['+'] = paste, ['*'] = paste },
  }
EOF
endif

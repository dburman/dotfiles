# Find dircolors executable
dircolors_exe=""
if [[ "$(uname -s)" == "Darwin" ]]; then
  gls --color -d . &>/dev/null 2>&1 && alias ls='gls -FqN --color=auto' || alias ls='ls -GF'
  gdircolors &> /dev/null 2>&1 && dircolors_exe=gdircolors
elif [[ $(uname) = 'FreeBSD' ]]; then
  ls --color -d . &>/dev/null 2>&1 && alias ls='ls -Fq --color=auto' || alias ls='ls -GF'
  dircolors &> /dev/null 2>&1 && dircolors_exe=dircolors
else
  ls --color -d . &>/dev/null 2>&1 && alias ls='ls -FqN --color=auto' || alias ls='ls -GF'
  dircolors &> /dev/null 2>&1 && dircolors_exe=dircolors
fi

# eza (Rust) supersedes the per-OS ls aliases above: it behaves identically on
# macOS, Alpine, Ubuntu and PopOS, so none of the GNU/BSD/busybox flag juggling
# applies to it. --classify=auto is eza's -F, and =auto (like --color=auto)
# suppresses the indicators when output is piped rather than shown in a terminal.
# eza reads LS_COLORS, so the dircolors setup below still feeds it.
# oh-my-zsh's ll/la/l/lsa chain through this alias and their -lh/-lAh/-lah all
# work under eza, so they need no changes.
if (( $+commands[eza] )); then
  alias ls='eza --classify=auto --color=auto'
fi

# Find config path, preferring ~/.dir_colors
dircolors_path=""
[ -f /etc/DIR_COLORS ] && dircolors_path="/etc/DIR_COLORS"
[ -f $HOME/.dir_colors ] && dircolors_path="$HOME/.dir_colors"

# Apply dircolors
if [ -n "$dircolors_exe" ]; then
  if [ -n "$dircolors_path" ]; then
    eval $($dircolors_exe -b $dircolors_path)
  else
    eval $($dircolors_exe --print-database)
  fi
fi

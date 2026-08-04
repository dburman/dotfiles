
source ~/.zsh/checks.zsh
source ~/.zsh/setopt.zsh
source ~/.zsh/history.zsh

# Must precede the plugin block: oh-my-zsh's git plugin calls compdef, which
# only exists after compinit. completion.zsh guards against running it twice.
source ~/.zsh/completion.zsh

if true; then
 source ~/.zsh/antidote.zsh
else
 autoload -Uz promptinit; promptinit
 PROMPT=$'%(!:%{$fg_bold[red]%}:%{$fg_no_bold[green]%})%n@%m %{$fg_no_bold[green]%}%D{[%I:%M:%S]} %{$fg_no_bold[cyan]%}%3~ %{$fg_no_bold[blue]%}%(1j:(%j %(2j:jobs:job)%) :)  %(?:%{$fg_no_bold[green]%}\n➜ %{$reset_color%}'
fi

# Deliberately sourced AFTER the plugin block. oh-my-zsh's lib/theme-and-
# appearance.zsh aliases ls itself (`ls -G` on macOS at :65, `ls --color=tty`
# on Linux at :73), which silently clobbered the alias this file defines - we
# were losing -F everywhere, plus -q and -N on Linux. Loading it last makes our
# intent win. Note this must stay after the plugin block, not before it.
# (DISABLE_LS_COLORS=true is not the fix: omz's early return sits at :24 but
# LSCOLORS is exported at :27, so setting it would also drop that palette.)
source ~/.zsh/dircolors.zsh

# Prefer neovim, fall back to vim, then vi. No hardcoded paths: the prefix
# differs per platform (/opt/homebrew on Apple Silicon, /usr/local on Intel,
# /usr/bin on Linux/BSD), so resolve it at runtime.
if (( $+commands[nvim] )); then
  export EDITOR=$commands[nvim]
elif (( $+commands[vim] )); then
  export EDITOR=$commands[vim]
else
  export EDITOR=$commands[vi]
fi
export VISUAL=$EDITOR

# Bind keys
bindkey -v
bindkey "\e[H"  beginning-of-line
bindkey "\e[F"  end-of-line

set -o vi
autoload -U colors; colors

source ~/.zsh/alias.zsh
source ~/.zsh/secret.zsh
#[[ -s "/Users/dburman/.gvm/bin/gvm-init.sh" ]] && source "/Users/dburman/.gvm/bin/gvm-init.sh"
source ~/.zsh/path.zsh
source ~/.zsh/prune-paths.zsh


# neofetch was archived upstream in 2024; prefer fastfetch, fall back if absent.
if (( $+commands[fastfetch] )); then
  fastfetch
elif (( $+commands[neofetch] )); then
  neofetch
fi

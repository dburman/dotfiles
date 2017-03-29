
source ~/.zsh/checks.zsh
source ~/.zsh/setopt.zsh
source ~/.zsh/history.zsh
source ~/.zsh/dircolors.zsh

source ~/.zsh/completion.zsh

if true; then
 source ~/.zsh/antigen.zsh
else
 autoload -Uz promptinit; promptinit
 PROMPT=$'%(!:%{$fg_bold[red]%}:%{$fg_no_bold[green]%})%n@%m %{$fg_no_bold[green]%}%D{[%I:%M:%S]} %{$fg_no_bold[cyan]%}%3~ %{$fg_no_bold[blue]%}%(1j:(%j %(2j:jobs:job)%) :)  %(?:%{$fg_no_bold[green]%}\n➜ %{$reset_color%}'
fi

if [[ $(uname) = 'Darwin' ]]; then
 export EDITOR=/usr/local/bin/mvim
else
 if [[ -x `which nvim` ]]; then
   export EDITOR=/usr/bin/nvim
 else
   export EDITOR=/usr/bin/vi
 fi
fi

# Bind keys
bindkey -v
bindkey "\e[H"  beginning-of-line
bindkey "\e[F"  end-of-line

set -o vi
autoload -U colors; colors

source ~/.zsh/alias.zsh
#[[ -s "/Users/dburman/.gvm/bin/gvm-init.sh" ]] && source "/Users/dburman/.gvm/bin/gvm-init.sh"
source ~/.zsh/path.zsh
source ~/.zsh/prune-paths.zsh


source ~/.zsh/checks.zsh
source ~/.zsh/setopt.zsh
source ~/.zsh/history.zsh

autoload -Uz promptinit; promptinit
prompt adam1

bindkey -v

autoload -Uz compinit; compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
#eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

zstyle ':completion:*:descriptions' format '%U%B%d%b%u'

zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

#export COLORTERM=yes

#export EDITOR=/usr/bin/vim
export EDITOR=/usr/local/bin/mvim
#export PS1="[%T %d] # "

# GNU Colors

#[ -f /etc/DIR_COLORS ] && eval $(dircolors -b /etc/DIR_COLORS)
# export ZLSCOLORS="${LS_COLORS}"

#alias ls="ls --color=auto -h"
alias df="df -h"
alias ping="ping -c3"
#alias cgrep="grep --color=auto"
alias :q="exit"
alias :wq="exit"
alias vi="mvim"

if type -p colordiff &> /dev/null ; then alias diff="colordiff" ; fi
if type -p colorgcc &> /dev/null ; then alias gcc="colorgcc" ; fi
if type -p colortail &> /dev/null ; then alias tail="colortail" ; fi

# Bind keys
bindkey "\e[H"  beginning-of-line
bindkey "\e[F"  end-of-line

set -o vi
autoload -U colors; colors

 # SSH Completion
zstyle ':completion:*:scp:*' tag-order \
 files users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'

zstyle ':completion:*:scp:*' group-order \
 files all-files users hosts-domain hosts-host hosts-ipaddr

zstyle ':completion:*:ssh:*' tag-order \
 users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'

zstyle ':completion:*:ssh:*' group-order \
 hosts-domain hosts-host users hosts-ipaddr

export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:$PATH
#export PATH=$PATH:"/Applications/microchip/xc32/v1.31/bin"
export PATH="$HOME/.cargo/bin:$PATH"


[[ -s "/Users/dburman/.gvm/bin/gvm-init.sh" ]] && source "/Users/dburman/.gvm/bin/gvm-init.sh"

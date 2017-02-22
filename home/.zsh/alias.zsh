
alias df="df -h"
alias ping="ping -c3"

if [[ -x `which htop` ]]; then
 alias top="htop"
fi 

#alias cgrep="grep --color=auto"
alias :q="exit"
alias :wq="exit"

if [[ $(uname) = 'Darwin' ]]; then
 alias vi="mvim"
 if [[ -x `which brew` ]]; then
  alias updateos="brew update && brew upgrade && brew cleanup"
 fi
else
 if [[ -x `which nvim` ]]; then
  alias vi="nvim"
 fi

 if [[ $(uname) = 'Linux' ]]; then
  if [[ -x `which apt` ]]; then
   alias updateos="sudo apt update && sudo apt upgrade && sudo apt autoremove" 
  fi
 elif [[ $(uname) = 'FreeBSD' ]]; then
   alias updateos="echo 'freebse not supported'"
 fi
fi

if type -p colordiff &> /dev/null ; then alias diff="colordiff" ; fi
if type -p colorgcc &> /dev/null ; then alias gcc="colorgcc" ; fi
if type -p colortail &> /dev/null ; then alias tail="colortail" ; fi


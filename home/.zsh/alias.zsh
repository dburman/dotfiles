
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
elif [[ -x `which nvim` ]]; then
 alias vi="nvim"
fi

if type -p colordiff &> /dev/null ; then alias diff="colordiff" ; fi
if type -p colorgcc &> /dev/null ; then alias gcc="colorgcc" ; fi
if type -p colortail &> /dev/null ; then alias tail="colortail" ; fi



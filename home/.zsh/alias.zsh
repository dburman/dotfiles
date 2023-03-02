alias df="df -h"
alias ping="ping -c3"
alias docker-cup="docker-compose pull && docker-compose up --force-recreate --build -d && docker image prune -f"

#alias cgrep="grep --color=auto"
alias :q="exit"
alias :wq="exit"

if [[ -x `which keychain` ]]; then eval $(keychain --eval id_ed25519);fi

if [[ -x `which htop` ]]; then alias top="htop" ;fi

if [[ $(uname) = 'Darwin' ]]; then
  NB_CORES=$(sysctl hw.ncpu | awk '{print $2}')
  alias make="make -j$((NB_CORES+1)) -l${NB_CORES}"
  if [[ -x `which brew` ]]; then alias updateos="brew update && brew upgrade && brew cleanup && mas upgrade && softwareupdate -i -a" ;fi
  alias vi="vim"
elif [[ $(uname) = 'Linux' ]]; then
  NB_CORES=$(grep -c '^processor' /proc/cpuinfo)
  alias make="make -j$((NB_CORES+1)) -l${NB_CORES}"
  if [[ -x `which apt` ]]; then alias updateos="sudo apt update && sudo apt upgrade && sudo apt autoremove" ;fi
  if [[ -x `which vim` ]]; then alias vi="vim" ; elif [[ -x `which nvim` ]]; then alias vi="nvim" ;fi
elif [[ $(uname) = 'FreeBSD' ]]; then
  NB_CORES=$(sysctl hw.ncpu | awk '{print $2}')
  alias make="make -j$((NB_CORES+1))"
  alias updateos="echo 'freebsd not supported'"
  if [[ -x `which vim` ]]; then alias vi="vim" ; elif [[ -x `which nvim` ]]; then alias vi="nvim" ;fi
fi

if type -p colordiff &> /dev/null ; then
  alias diff="colordiff" ;
else
  if [[ -x `which vimdiff` ]]; then
    alias diff="vimdiff" ;
  fi
fi

if type -p colorgcc &> /dev/null ; then alias gcc="colorgcc" ;fi
if type -p colortail &> /dev/null ; then alias tail="colortail" ;fi

if [[ -x `which git` ]]; then
  alias gs="git status" ;
  alias gp="git pull && git submodule update --init" ;
fi

transfer(){ if [ $# -eq 0 ];then echo "No arguments specified.\nUsage:\n transfer <file|directory>\n ... | transfer <file_name>">&2;return 1;fi;if tty -s;then file="$1";file_name=$(basename "$file");if [ ! -e "$file" ];then echo "$file: No such file or directory">&2;return 1;fi;if [ -d "$file" ];then file_name="$file_name.zip" ,;(cd "$file"&&zip -r -q - .)|curl --progress-bar --upload-file "-" "https://xfer.muteink.com/$file_name"|tee /dev/null,;else cat "$file"|curl --progress-bar --upload-file "-" "https://xfer.muteink.com/$file_name"|tee /dev/null;fi;else file_name=$1;curl --progress-bar --upload-file "-" "https://xfer.muteink.com/$file_name"|tee /dev/null;fi;}

alias df="df -h"
alias ping="ping -c3"
#alias docker-cup="docker-compose pull && docker-compose up --force-recreate --build -d && docker image prune -f"
alias docker-cup="docker compose pull && docker compose up --force-recreate --build -d && docker image prune -f"

# Was living only in this machine's ~/.zshrc and would have been lost on the
# next sync2home.sh. Guarded so machines with real docker are unaffected.
if (( ! $+commands[docker] )) && (( $+commands[podman] )); then
  alias docker=podman
fi
#alias lazydocker="docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v ~/lazydocker:/.config/jesseduffield/lazydocker lazyteam/lazydocker"
alias :q="exit"
alias :wq="exit"

if [[ -x `which keychain` ]]; then eval $(keychain --eval --quiet id_ed25519);fi
if [[ -x `which glances` ]]; then alias top="glances"; elif [[ -x `which htop` ]]; then alias top="htop" ;fi

if [[ $(uname) = 'Darwin' ]]; then
  NB_CORES=$(sysctl hw.ncpu | awk '{print $2}')
  alias make="make -j$((NB_CORES+1)) -l${NB_CORES}"
  if [[ -x `which brew` ]]; then alias updateos="brew update && brew upgrade && brew cleanup && mas upgrade && softwareupdate -i -a" ;fi
  alias vi="nvim"

  #functions....
  replace(){ if [ $# -eq 0 ]; then echo "\nUsage:\n replace <findtext> <replacetext>\n"; return 1; else echo "\n-----------\n"; fi; rg "$1" . && echo "\n-----------\n"  && rg -l "$1" . | xargs sed -i '' "s/$1/$2/g" && rg "$2" . && echo "\n-----------\n";}
elif [[ $(uname) = 'Linux' ]]; then
  NB_CORES=$(grep -c '^processor' /proc/cpuinfo)
  alias make="make -j$((NB_CORES+1)) -l${NB_CORES}"
  # Ubuntu/PopOS (apt), Arch (pacman), Alpine (apk).
  # On Arch, prefer an AUR helper if installed: paru/yay run `pacman -Syu` and
  # then update AUR packages too. They call sudo themselves, so no sudo prefix.
  if (( $+commands[apt] )); then
    _updateos="sudo apt update && sudo apt upgrade && sudo apt autoremove"
  elif (( $+commands[pacman] )); then
    if (( $+commands[paru] )); then
      _updateos="paru -Syu"
    elif (( $+commands[yay] )); then
      _updateos="yay -Syu"
    else
      _updateos="sudo pacman -Syu"
    fi
  elif (( $+commands[apk] )); then
    _updateos="sudo apk update && sudo apk upgrade"
  fi
  (( $+commands[flatpak] )) && [[ -n $_updateos ]] && _updateos+=" && flatpak update"
  [[ -n $_updateos ]] && alias updateos=$_updateos
  unset _updateos
  if (( $+commands[nvim] )); then alias vi="nvim" ; elif (( $+commands[vim] )); then alias vi="vim" ;fi

  #functions....
  replace(){ if [ $# -eq 0 ]; then echo "\nUsage:\n replace <findtext> <replacetext>\n"; return 1; else echo "\n-----------\n"; fi; rg "$1" . && echo "\n-----------\n"  && rg -l "$1" . | xargs sed -i  "s/$1/$2/g" && rg "$2" . && echo "\n-----------\n";}
elif [[ $(uname) = 'FreeBSD' ]]; then
  NB_CORES=$(sysctl hw.ncpu | awk '{print $2}')
  alias make="make -j$((NB_CORES+1))"
  alias updateos="sudo pkg upgrade"
  if (( $+commands[nvim] )); then alias vi="nvim" ; elif (( $+commands[vim] )); then alias vi="vim" ;fi

  #functions....
  replace(){ if [ $# -eq 0 ]; then echo "\nUsage:\n replace <findtext> <replacetext>\n"; return 1; else echo "\n-----------\n"; fi; rg "$1" . && echo "\n-----------\n"  && rg -l "$1" . | xargs sed -i '' "s/$1/$2/g" && rg "$2" . && echo "\n-----------\n";}
fi

# sd (Rust) replaces `sed -i` and behaves identically everywhere, so this single
# definition supersedes the three above -- which differ only because BSD/macOS
# `sed -i` needs a backup-suffix argument and GNU does not. The sed versions stay
# as the fallback for machines without sd.
#
# Note this checks for 2 args, not 0 like the fallbacks: called with a single
# argument the old form ran s/$1//g and silently deleted every match.
if (( $+commands[sd] )); then
  replace(){
    if [ $# -lt 2 ]; then echo "\nUsage:\n replace <findtext> <replacetext>\n"; return 1; else echo "\n-----------\n"; fi
    rg "$1" . && echo "\n-----------\n" && rg -l "$1" . | xargs sd "$1" "$2" && rg "$2" . && echo "\n-----------\n"
  }
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

#functions....
transfer(){ if [ $# -eq 0 ];then echo "No arguments specified.\nUsage:\n transfer <file|directory>\n ... | transfer <file_name>">&2;return 1;fi;if tty -s;then file="$1";file_name=$(basename "$file");if [ ! -e "$file" ];then echo "$file: No such file or directory">&2;return 1;fi;if [ -d "$file" ];then file_name="$file_name.zip" ,;(cd "$file"&&zip -r -q - .)|curl --progress-bar --upload-file "-" "https://xfer.muteink.com/$file_name"|tee /dev/null,;else cat "$file"|curl --progress-bar --upload-file "-" "https://xfer.muteink.com/$file_name"|tee /dev/null;fi;else file_name=$1;curl --progress-bar --upload-file "-" "https://xfer.muteink.com/$file_name"|tee /dev/null;fi;}

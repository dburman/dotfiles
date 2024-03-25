ADOTDIR=$HOME/.antigen

# Download and install antigen if it doesn't exist
if [ ! -f "$ADOTDIR/antigen/antigen.zsh" ]; then
  echo "zsh antigen not installed - cloning..."
  mkdir -p "$ADOTDIR" && git clone https://github.com/zsh-users/antigen "$ADOTDIR/antigen"
fi

# Install antigen plugins
source "$ADOTDIR/antigen/antigen.zsh"
antigen use oh-my-zsh
#antigen bundles <<EOBUNDLES
#    colored-man-pages
#    command-not-found
#    history
#    rupa/z
#    zsh-users/zsh-completions
#    zsh-users/zsh-syntax-highlighting
#    radhermit/gentoo-zsh-completions
#    lukechilds/zsh-nvm
#EOBUNDLES

antigen bundles <<EOBUNDLES
    git
    colored-man-pages
    command-not-found
    zsh-users/zsh-syntax-highlighting
EOBUNDLES

antigen theme ~/.zsh themes/doitchbig
antigen apply


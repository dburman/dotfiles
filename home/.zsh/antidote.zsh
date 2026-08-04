# Plugin loading via antidote, which replaced antigen (unmaintained since
# 2019-12-22). Bundle list lives in zsh_plugins.txt.
#
# NOTE: completion.zsh must be sourced BEFORE this file. oh-my-zsh's git plugin
# calls compdef ~10 times, and compdef only exists once compinit has run. That
# used to be handled by oh-my-zsh.sh:127; we no longer load oh-my-zsh.sh, so the
# ordering in .zshrc is what guarantees it.

# Where antidote itself is installed. Deliberately NOT named ANTIDOTE_HOME:
# antidote uses that variable for its bundle *storage* directory, and reusing it
# would make antidote clone bundles into its own source tree.
ANTIDOTE_DIR=${ANTIDOTE_DIR:-$HOME/.antidote}

# Bootstrap on a new machine, mirroring how antigen.zsh used to self-install.
if [[ ! -f "$ANTIDOTE_DIR/antidote.zsh" ]]; then
  echo "antidote not installed - cloning..."
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR" || return 1
fi

source "$ANTIDOTE_DIR/antidote.zsh"

# Compile the manifest to a static file and source that, so bundle resolution
# doesn't happen on every shell start. Regenerated whenever the .txt is newer.
zsh_plugins=${HOME}/.zsh/zsh_plugins
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
fi

# Several oh-my-zsh lib files (cli.zsh, functions.zsh, diagnostics.zsh) read
# $ZSH. antigen set it via `antigen use oh-my-zsh`; set it ourselves. Must come
# after the bundle step above, which is what clones oh-my-zsh on a new machine.
export ZSH="$(antidote home)/github.com/ohmyzsh/ohmyzsh"

source ${zsh_plugins}.zsh

# $fg_bold / $fg_no_bold used by the theme below. Previously this came for free
# from oh-my-zsh's lib/theme-and-appearance.zsh, which `antigen use oh-my-zsh`
# pulled in; we only import lib/git.zsh now, so initialize colors explicitly.
autoload -Uz colors && colors

# Local theme (not a bundle) - source directly.
source ${HOME}/.zsh/themes/doitchbig.zsh-theme

# dotfiles

## Prompt (powerlevel10k)

The prompt is [powerlevel10k](https://github.com/romkatv/powerlevel10k), loaded by antidote from
`home/.zsh/zsh_plugins.txt`. Its config is `home/.zsh/p10k.zsh`; rerun `p10k configure` to change it.

It needs the patched **MesloLGS NF** font, installed on the machine that runs the *terminal
emulator* (over SSH, that's your local machine, not the remote one). Then set your terminal's
font to `MesloLGS NF`.

```bash
# macOS
brew install --cask font-meslo-for-powerlevel10k

# Linux desktop (e.g. PopOS)
mkdir -p ~/.local/share/fonts && cd ~/.local/share/fonts
for s in Regular Bold Italic 'Bold Italic'; do
  curl -fLO "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20${s// /%20}.ttf"
done
fc-cache -f
```

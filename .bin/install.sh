#!/bin/bash

git clone --bare https://github.com/WolfBublitz/Dotfiles.git $HOME/.dotfiles

function dotfiles {
   /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

dotfiles config --local status.showUntrackedFiles no

dotfiles checkout --force

if [ -x "$(command -v zsh)" ]; then
   git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
   git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
   git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ~/.zsh/zsh-autocomplete
fi

declare -a tools=(fastfetch htop lsd unzip vim)

for tool in "${tools[@]}"
do
   echo "[INFO] Checking" $tool
   if [ -x "$(command -v $tool)" ]; then
      echo "[SUCC]" $tool " found"
   else
      echo "[WARN]" $tool " not found"
   fi
done

echo "[INFO] Checking oh my posh"
if [ -x "$(command -v oh-my-posh)" ]; then
   echo "[SUCC] oh-my-posh found"
else
   echo "[WARN] oh-my-posh not found"
fi

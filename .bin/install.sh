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

declare -a tools=(neofetch htop unzip vim)

for tool in "${tools[@]}"
do
   echo "[INFO] Checking " $tool
   if ! [ -x "$(command -v $tool)" ]; then
      echo "[INFO] Installing " $tool
      if [ -x "$(command -v apt-get)" ]; then
         sudo -- sh -c `apt-get install -y $tool`
      fi
   fi
done

if ! [ -x "$(command -v oh-my-posh)" ]; 
   echo "[INFO] Installing oh my posh"
   sudo -- sh -c 'curl -s https://ohmyposh.dev/install.sh | bash -s'
fi

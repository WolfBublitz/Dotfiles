#!/bin/bash

echo "Installing Oh My Posh for ZSH"

if [ -f ~/.zshrc ]; then
    echo "-> Backing up ~/.zshrc to ~/.zshrc.bak"
    cp ~/.zshrc ~/.zshrc.bak
    rm ~/.zshrc
fi

echo eval "$(oh-my-posh init zsh --config ~/.poshthemes/theme.omp.json)" >> ~/.zshrc

#!/bin/bash

echo "Installing Oh My Posh for Bash"

if [ -f ~/.bashrc ]; then
    echo "-> Backing up ~/.bashrc to ~/.bashrc.bak"
    cp ~/.bashrc ~/.bashrc.bak
    rm ~/.bashrc
fi

echo eval "$(oh-my-posh init bash --config ~/.poshthemes/theme.omp.json)" >> ~/.bashrc

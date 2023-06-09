#!/bin/bash

echo "Installing Oh My Posh"

# installing oh my posh
curl -s https://ohmyposh.dev/install.sh | bash -s

# copying theme
mkdir -p ~/.poshthemes
cp theme.omp.json ~/.poshthemes/theme.omp.json

if [ -x "$(command -v bash)" ]; then
    ./install-bash.sh
fi

if [ -x "$(command -v pwsh)" ]; then
    pwsh install-pwsh.ps1
fi

if [ -x "$(command -v zsh)" ]; then
    ./install-zsh.sh
fi

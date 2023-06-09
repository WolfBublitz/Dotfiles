#!/bin/bash

echo "installing oh my posh"

cd oh-my-posh

# installing oh my posh
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d /usr/bin

# copying theme
cp theme.omp.json ~/theme.omp.json

if [ -x "$(command -v bash)" ]; then
    echo "Installing Oh My Posh for Bash"
    ./install-bash.sh
fi

if [ -x "$(command -v pwsh)" ]; then
    echo "Installing Oh My Posh for Pwsh"
    pwsh install-pwsh.ps1  
fi

cd ..

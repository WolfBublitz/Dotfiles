#!/bin/bash

echo "installing oh my posh"

cd oh-my-posh

curl -s https://ohmyposh.dev/install.sh | bash -s -- -d /usr/bin

cp theme.omp.json $OMP_THEMES_DIR

if [ -x "$(command -v base)" ]; then
    echo "Installing Oh My Posh for Bash"
    echo eval "$(oh-my-posh init bash --config ~/theme.omp.json)" >> ~/.bashrc
fi

if [ -x "$(command -v pwsh)" ]; then
    echo "Installing Oh My Posh for Pwsh"
    pwsh install-pwsh.ps1  
fi

cd ..

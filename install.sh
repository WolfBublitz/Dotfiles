#!/bin/bash

cd oh-my-posh
./install.sh
cd ..

if [ -x "$(command -v bash)" ]; then
    cd bash
    ./install.sh
    cd ..
fi

if [ -x "$(command -v pwsh)" ]; then
    cd pwsh
    pwsh install.ps1
    cd ..
fi

if [ -x "$(command -v zsh)" ]; then
    cd zsh
    ./install.sh
    cd ..
fi

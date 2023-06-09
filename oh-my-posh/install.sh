#!/bin/bash

echo "installing oh my posh"

cd oh-my-posh

OMP_DIR=~/bin
OMP_THEMES_DIR=~/.poshthemes

if [[ ! -d $OMP_DIR ]]; then
    mkdir $OMP_DIR
fi

curl -s https://ohmyposh.dev/install.sh | bash -s -- -d $OMP_DIR

#$OMP_DIR/oh-my-posh font install

if [[ ! -d $OMP_THEMES_DIR ]]; then
    mkdir ~/.poshthemes
fi

cp theme.omp.json $OMP_THEMES_DIR

echo eval "$($OMP_DIR/oh-my-posh init bash --config $OMP_THEMES_DIR/theme.omp.json)" >> ~/.bashrc

mkdir -p ~/.config/powershell
echo eval "$($OMP_DIR/oh-my-posh init pwsh --config $OMP_THEMES_DIR/theme.omp.json)" >> ~/.config/powershell/Microsoft.PowerShell_profile.ps1

cd ..

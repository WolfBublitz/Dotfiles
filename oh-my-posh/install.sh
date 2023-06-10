#!/bin/bash

echo "Installing Oh My Posh"

# installing oh my posh
curl -s https://ohmyposh.dev/install.sh | bash -s

# copying theme
echo "-> copying theme"
mkdir -p ~/.poshthemes
cp theme.omp.json ~/.poshthemes/theme.omp.json

# installing fonts
echo "-> installing font FiraCode"
oh-my-posh font install FiraCode

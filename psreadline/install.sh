#!/bin/bash

if [ -x "$(command -v pwsh)" ]; then
  echo "Installing PSReadLine for Powershell"
  
  cd psreadline
  
  pwsh install-pwsh.ps1
  
  cd ..
fi

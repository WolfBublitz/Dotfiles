#!/bin/bash

if [ -x "$(command -v pwsh)" ]; then
  echo "Installing PSReadLine for Powershell"

  pwsh install-pwsh.ps1
fi

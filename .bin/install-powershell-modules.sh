#!/bin/bash

pwsh -c "Install-Module -Name PSReadLine -AllowClobber -Force"
pwsh -c "Install-Module -Name CompletionPredictor -Force"
pwsh -c "Install-Module -Name PwshSpectreConsole  -Force"

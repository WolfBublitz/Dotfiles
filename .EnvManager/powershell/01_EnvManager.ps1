$env:PATH = "$HOME/.local/bin$([IO.Path]::PathSeparator)$env:PATH"
Set-Alias -Name em -Value EnvManager

using namespace System;
using namespace System.IO;
using namespace System.Globalization;

$hostname = $(Get-Host).Name

if ($hostname -eq 'ConsoleHost' -or $hostname -eq 'Visual Studio Code Host' ) {
    function dotfiles {
        git --git-dir=$HOME/.dotfiles --work-tree=$HOME @args
    }
}

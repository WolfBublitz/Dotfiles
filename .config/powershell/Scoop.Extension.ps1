Function Install-Scoop {
    If ($IsWindows) {
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
        Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    }
    else {
        throw "Scoop is only available on Windows."
    }
}
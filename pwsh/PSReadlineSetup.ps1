$hostname = $(Get-Host).Name

if ($hostname -eq 'ConsoleHost' -or $hostname -eq 'Visual Studio Code Host' ) {

    # configuring PSReadLine
    Import-Module PSReadLine


    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
    Set-PSReadLineOption -HistorySearchCursorMovesToEnd

    Set-PSReadLineKeyHandler -Key Alt+d -Function ShellKillWord
    Set-PSReadLineKeyHandler -Key Alt+Backspace -Function ShellBackwardKillWord
    Set-PSReadLineKeyHandler -Key Alt+LeftArrow -Function ShellBackwardWord
    Set-PSReadLineKeyHandler -Key Alt+RightArrow -Function ShellForwardWord

    Set-PSReadlineOption -Color @{
        "Command"                = $PSStyle.Bold + $PSStyle.Foreground.FromRgb(0x0595f5)
        "Comment"                = $PSStyle.Foreground.White
        "ContinuationPrompt"     = '#7FFFD4'
        "Default"                = '#50C878'
        "Emphasis"               = $PSStyle.Foreground.Black
        "Error"                  = '#7DF9FF'
        "InlinePrediction"       = '#00A36C'
        "Keyword"                = '#32CD32'
        "ListPrediction"         = '#0FFF50'
        "ListPredictionSelected" = $PSStyle.Reverse
        "Member"                 = '#40E0D0'
        "Number"                 = $PSStyle.Foreground.FromRgb(0x0595f5)
        "Operator"               = $PSStyle.Foreground.White
        "Parameter"              = $PSStyle.Foreground.BrightWhite
        "Selection"              = $PSStyle.Reverse
        "String"                 = $PSStyle.Foreground.BrightYellow
        "Type"                   = '#C1E1C1'
        "Variable"               = $PSStyle.Foreground.Green
    }
}

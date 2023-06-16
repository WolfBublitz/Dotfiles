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
        "Command"                = '#AAFF00'
        "Comment"                = '#00FFFF'
        "ContinuationPrompt"     = '#7FFFD4'
        "Default"                = '#50C878'
        "Emphasis"               = '#C4B454'
        "Error"                  = '#7DF9FF'
        "InlinePrediction"       = '#00A36C'
        "Keyword"                = '#32CD32'
        "ListPrediction"         = '#0FFF50'
        "ListPredictionSelected" = '#CC5500'
        "Member"                 = '#40E0D0'
        "Number"                 = '#C9CC3F'
        "Operator"               = '#93C572'
        "Parameter"              = '#00FF7F'
        "Selection"              = '#FF5F1F'
        "String"                 = '#40B5AD'
        "Type"                   = '#C1E1C1'
        "Variable"               = '#0BDA51'
    }
}

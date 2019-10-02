Get-ChildItem -Path $PSScriptRoot | Unblock-File
Get-ChildItem -Path "$PSScriptRoot\*.ps1" | % { . $_.FullName }

Export-ModuleMember -Function * -Alias *
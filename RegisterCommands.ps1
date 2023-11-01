$ScriptDirectory = $PSScriptRoot
[System.Environment]::SetEnvironmentVariable("PATH", $env:Path + ";" + $ScriptDirectory, [System.EnvironmentVariableTarget]::User)
Write-Output "Scripts register completed. Check README for commands."
$ScriptDirectory = $PSScriptRoot
Get-Item .\RunMigration.ps1 | Select-Object -ExpandProperty Directory
[System.Environment]::SetEnvironmentVariable("PATH", $env:Path + ";" + $ScriptDirectory, [System.EnvironmentVariableTarget]::User)

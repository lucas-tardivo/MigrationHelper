﻿param(
	[switch]$clearCache
)

$ProjectPath = $PWD;
$ProjectName = Split-Path -Path $ProjectPath -Leaf
$Directory = Join-Path $env:APPDATA "MigrationHelper"
$JsonFilePath = "$Directory\$ProjectName.json"

$ConfigJson = '
{
    "Provider": "",
    "Host": "",
    "LoggingDatabase": "",
    "GameDatabase": "",
    "PlayerDatabase": "",
    "User": "",
    "Password": ""
}
'

$Config = $ConfigJson | ConvertFrom-Json

if (!(Test-Path -Path $Directory -PathType Container)) {
    New-Item -ItemType Directory -Path $Directory
}else{
    if (Test-Path -Path $JsonFilePath -PathType Leaf) {
        $JsonContext = Get-Content -Path $JsonFilePath -Raw

        $Config = $JsonContext | ConvertFrom-Json
    }
}

if ([string]::IsNullOrEmpty($Config.Provider) -or $clearCache) {
    $provider = Read-Host "Migration Provider (Example: MySql or Sqlite)"
    $Config.Provider = $provider
}

if ($Config.Provider.ToLower() -eq "mysql") {
    if ([string]::IsNullOrEmpty($Config.User)) {
        $LoggingDatabase = Read-Host "Logging Database"
        $GameDatabase = Read-Host "Game Database"
        $PlayerDatabase = Read-Host "Player Database"
        $User = Read-Host "Username"
        $Password = Read-Host "Password"

        $Config.LoggingDatabase = $LoggingDatabase
        $Config.GameDatabase = $GameDatabase
        $Config.PlayerDatabase = $PlayerDatabase
        $Config.User = $User
        $Config.Password = $Password
    }
}

$ConfigJson = $Config | ConvertTo-Json
$ConfigJson | Set-Content -Path $JsonFilePath

$MigrationName = Read-Host "Migration name"
$ContextStr = Read-Host "Context (G = GameContext, P = PlayerContext, L = LoggingContext)"

switch ($ContextStr.ToLower()) {
    p {
        $ContextRootName = "Player"
        $Database = $Config.PlayerDatabase
      }
    g {
        $ContextRootName = "Game"
        $Database = $Config.GameDatabase
      }
    l {
        $ContextRootName = "Logging"
        $Database = $Config.LoggingDatabase
      }
}

$Context = $Config.Provider + $ContextRootName + "Context"

$CommandString = "migrations add $MigrationName --context $Context --namespace Intersect.Server.Migrations." + $Config.Provider + ".$ContextRootName --output-dir Migrations/" + $Config.Provider + "/$ContextRootName/" 
$Namespace = "Intersect.Server.Migrations." + $Config.Provider
$OutputDir = "Migrations/" + $Config.Provider + "/$ContextRootName/"

if ($Config.Provider.ToLower() -eq "mysql") {
    $ConnectionString = "Username=" + $Config.User + ";Password=" + $Config.Password + ";Database=$Database"
    cd Join-Path $PWD "Intersect.Server"
    cd $ServerPath
    dotnet-ef migrations add $MigrationName --context $Context --namespace $Namespace --output-dir $OutputDir --connectionString $ConnectionString -- --databaseType $Config.Provider
}else{
    $StartupProject = "../Intersect.Server/"
    $ServerPath = Join-Path $PWD "Intersect.Server.Core"
    cd $ServerPath
    dotnet-ef migrations add $MigrationName --context $Context --namespace $Namespace --output-dir $OutputDir --startup-project $StartupProject -- --databaseType $Config.Provider
}

cd $ProjectPath
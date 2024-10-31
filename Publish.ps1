param(
	
)

# Script for publishing projects into a zip folder

$ProjectPath = $PWD;
$ProjectName = Split-Path -Path $ProjectPath -Leaf
$ClientPath = "$PWD\Intersect.Client\bin\Release\net7.0\win-x64\publish\*"
$EditorPath = "$PWD\Intersect.Editor\bin\Release\net7.0-windows\win-x64\publish\*"
$ServerPath = "$PWD\Intersect.Server\bin\Release\net7.0\win-x64\publish\*"
$desktopPath = [System.Environment]::GetFolderPath('Desktop')
$date = (Get-Date).ToString("dd-MM-yyyy")
$OutputPath = "$desktopPath\$ProjectName $date"

Write-Host "Cleaning destiny folders..."

Remove-Item -Path "$ClientPath\*" -Recurse -Force
Remove-Item -Path "$EditorPath\*" -Recurse -Force
Remove-Item -Path "$ServerPath\*" -Recurse -Force

Write-Host "Publishing..."

dotnet publish -p:Configuration=Release -p:PackageVersion=0.8.0-beta -p:Version=0.8.0 -r win-x64 > $null

Start-Sleep -Seconds 5

Write-Host "Zipping files in the output folder..."

if (-not (Test-Path -Path $OutputPath)) {
    New-Item -Path $OutputPath -ItemType Directory
}

Write-Host "Zipping client..."
Compress-Archive -Path $ClientPath -DestinationPath "$OutputPath\Client.zip" > $null

Write-Host "Zipping editor..."
Compress-Archive -Path $EditorPath -DestinationPath "$OutputPath\Editor.zip" > $null

Write-Host "Zipping server..."
Compress-Archive -Path $ServerPath -DestinationPath "$OutputPath\Server.zip" > $null

Write-Host "Zipping output to an unique file..."
Compress-Archive -Path "$OutputPath\*" -Force -DestinationPath "$OutputPath.zip" > $null

Remove-Item -Path $OutputPath -Recurse

Start-Process explorer.exe "/select,`"$OutputPath.zip`""

Write-Host "Publishing completed!"
Write-Host "Output files moved to $OutputPath"
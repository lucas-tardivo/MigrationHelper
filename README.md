# MigrationHelper
Migration script helper for Intersect

## Pre-requisites
- Installed dotnet ef tools globally.
- Set the Powershell execution policy as 'Unrestricted': **Set-ExecutionPolicy Unrestricted**

## How to use
- Open **RegisterCommmands.ps1** in Powershell IDE or run it directly from the terminal.
- Go to the root folder of your project.
- Run any commands described.

## Commands
### RunMigration [-clearCache]
#### Description
Run a new migration command for your project. In case of an already known project, the last configuration will be used unless you use the **clearCache** parameter.
#### Parameters
- clearCache (optional)
  - Ignore any saved configuration for this current project.
#### Example
- RunMigration [-clearCache]

## Credits
**Author:** boasfesta
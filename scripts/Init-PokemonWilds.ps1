[CmdletBinding()]
param(
    [string]$ProjectPath = 'C:\Users\유2023610042\Desktop\pokemonwilds',
    [switch]$InitGit
)

$ErrorActionPreference = 'Stop'
New-Item -ItemType Directory -Force -Path $ProjectPath | Out-Null
foreach ($dir in @('docs', 'scripts', 'config', 'src', 'assets', 'tests')) {
    New-Item -ItemType Directory -Force -Path (Join-Path $ProjectPath $dir) | Out-Null
}

if ($InitGit -and -not (Test-Path (Join-Path $ProjectPath '.git'))) {
    git -C $ProjectPath init
}

Write-Host "Pokemon Wilds project folders are ready: $ProjectPath" -ForegroundColor Green

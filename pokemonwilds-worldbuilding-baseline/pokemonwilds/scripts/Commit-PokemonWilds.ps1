[CmdletBinding()]
param(
    [string]$ProjectPath = 'C:\Users\유2023610042\Desktop\pokemonwilds',
    [string]$Message = 'docs: save Pokemon Wilds worldbuilding baseline',
    [switch]$Push
)

$ErrorActionPreference = 'Stop'
if (-not (Test-Path $ProjectPath)) { throw "Project path not found: $ProjectPath" }
if (-not (Test-Path (Join-Path $ProjectPath '.git'))) { git -C $ProjectPath init }

git -C $ProjectPath add .
if ((git -C $ProjectPath diff --cached --name-only).Count -eq 0) {
    Write-Host 'No staged changes.' -ForegroundColor Yellow
    exit 0
}
git -C $ProjectPath commit -m $Message
if ($Push) {
    git -C $ProjectPath branch -M main
    $remote = git -C $ProjectPath remote get-url origin 2>$null
    if (-not $remote) { git -C $ProjectPath remote add origin 'https://github.com/kevinyu1212/pokemonwilds.git' }
    git -C $ProjectPath push -u origin main
}

<#
manage_stories.ps1
Simple helper to add/remove story files and update `stories/index.json`.

Usage examples (run in PowerShell from project root `c:\Users\aa\Downloads\web`):

# Add a file (copy from anywhere):
# .\scripts\manage_stories.ps1 -AddPath "C:\Users\aa\Desktop\my-story.txt"

# Remove a file by name (exact filename):
# .\scripts\manage_stories.ps1 -RemoveName "my-story.txt"

# Rebuild index.json from the files currently in `stories/`:
# .\scripts\manage_stories.ps1 -RebuildIndex

# Notes:
# - This script will copy files into `stories/` and update `stories/index.json`.
# - It will not overwrite existing filenames unless you pass -Force.
# - Run PowerShell as appropriate to have write permissions.
#>

param(
    [Parameter(Mandatory=$false)] [string] $AddPath,
    [Parameter(Mandatory=$false)] [string] $RemoveName,
    [switch] $RebuildIndex,
    [switch] $Force
)

$root = Split-Path -Parent $MyInvocation.MyCommand.Definition
$projectRoot = Resolve-Path (Join-Path $root "..")
$storiesDir = Join-Path $projectRoot "stories"
$indexFile = Join-Path $storiesDir "index.json"

if(-not (Test-Path $storiesDir)){
    New-Item -ItemType Directory -Path $storiesDir | Out-Null
}

function Write-Index([string[]] $names){
    $json = $names | ConvertTo-Json -Depth 10
    Set-Content -Path $indexFile -Value $json -Encoding UTF8
    Write-Host "Updated index: $indexFile" -ForegroundColor Green
}

if($AddPath){
    if(-not (Test-Path $AddPath)){
        Write-Host "File to add not found: $AddPath" -ForegroundColor Red; exit 1
    }
    $base = Split-Path $AddPath -Leaf
    $dest = Join-Path $storiesDir $base
    if(Test-Path $dest -and -not $Force){
        Write-Host "Destination file already exists: $dest. Use -Force to overwrite." -ForegroundColor Yellow; exit 2
    }
    Copy-Item -Path $AddPath -Destination $dest -Force:$Force
    Write-Host "Copied to: $dest" -ForegroundColor Green
    # Rebuild index
    $files = Get-ChildItem -Path $storiesDir -File | Where-Object { $_.Extension -match '\.txt$' } | Select-Object -ExpandProperty Name
    Write-Index -names $files
    exit 0
}

if($RemoveName){
    $target = Join-Path $storiesDir $RemoveName
    if(Test-Path $target){ Remove-Item -Path $target -Force; Write-Host "Removed $target" -ForegroundColor Green } else { Write-Host "File not found: $RemoveName" -ForegroundColor Yellow }
    # Rebuild index
    $files = Get-ChildItem -Path $storiesDir -File | Where-Object { $_.Extension -match '\.txt$' } | Select-Object -ExpandProperty Name
    Write-Index -names $files
    exit 0
}

if($RebuildIndex){
    $files = Get-ChildItem -Path $storiesDir -File | Where-Object { $_.Extension -match '\.txt$' } | Select-Object -ExpandProperty Name
    Write-Index -names $files
    exit 0
}

Write-Host "No action specified. Use -AddPath, -RemoveName, or -RebuildIndex." -ForegroundColor Yellow

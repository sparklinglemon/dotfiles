# Copies Windows-side configs from this repo to where the apps look for them.
# Re-run after pulling changes. Existing files are backed up with a .bak suffix.

$ErrorActionPreference = 'Stop'

$targets = @{
    '.wezterm.lua' = Join-Path $env:USERPROFILE '.wezterm.lua'
    'kanata.kbd'   = Join-Path $env:APPDATA 'kanata\kanata.kbd'
}

foreach ($name in $targets.Keys) {
    $source = Join-Path $PSScriptRoot $name
    $destination = $targets[$name]

    New-Item -ItemType Directory -Force -Path (Split-Path $destination) | Out-Null

    if ((Test-Path $destination) -and
        (Get-FileHash $destination).Hash -ne (Get-FileHash $source).Hash) {
        Copy-Item $destination "$destination.bak" -Force
        Write-Host "Backed up $destination"
    }

    Copy-Item $source $destination -Force
    Write-Host "Installed $name -> $destination"
}

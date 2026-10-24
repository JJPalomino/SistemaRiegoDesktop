# Genera la build de Release y el instalador .exe con Inno Setup.
#
# Uso (desde cualquier carpeta):
#   powershell -ExecutionPolicy Bypass -File installer\build_installer.ps1

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
Push-Location $root
try {
    Write-Host '==> Compilando la aplicacion (Release)...' -ForegroundColor Cyan
    flutter build windows
    if ($LASTEXITCODE -ne 0) { throw 'flutter build windows fallo.' }

    $candidatos = @(
        "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe",
        'C:\Program Files (x86)\Inno Setup 6\ISCC.exe',
        'C:\Program Files\Inno Setup 6\ISCC.exe'
    )
    $iscc = $candidatos | Where-Object { Test-Path $_ } | Select-Object -First 1
    if (-not $iscc) {
        throw 'No se encontro Inno Setup. Instalalo con: winget install JRSoftware.InnoSetup'
    }

    Write-Host '==> Generando el instalador...' -ForegroundColor Cyan
    & $iscc 'installer\sistema_riego.iss'
    if ($LASTEXITCODE -ne 0) { throw 'Inno Setup fallo al compilar el instalador.' }

    $setup = Get-ChildItem 'dist\SistemaRiego-Setup-*.exe' |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1
    Write-Host "==> Listo: $($setup.FullName)" -ForegroundColor Green
}
finally {
    Pop-Location
}

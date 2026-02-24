param(
    [int]$Port = 5000,
    [switch]$NoBrowser
)

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $projectRoot

$waitressArgs = @("-m", "waitress", "--host=0.0.0.0", "--port=$Port", "src.app:app")

if (Get-Command python -ErrorAction SilentlyContinue) {
    $pythonExe = (Get-Command python).Source
    $pythonArgs = $waitressArgs
} elseif (Get-Command py -ErrorAction SilentlyContinue) {
    $pythonExe = (Get-Command py).Source
    $pythonArgs = @("-3") + $waitressArgs
} else {
    throw "No se encontró Python en PATH."
}

$portInUse = netstat -ano | Select-String -Pattern (":$Port\s+.*LISTENING")
if (-not $portInUse) {
    Start-Process -FilePath $pythonExe -ArgumentList $pythonArgs -WorkingDirectory $projectRoot | Out-Null
    Start-Sleep -Seconds 2
    Write-Host "Servidor iniciado con Waitress en http://127.0.0.1:$Port"
} else {
    Write-Host "Ya hay un proceso escuchando en el puerto $Port."
}

if (-not $NoBrowser) {
    if (Get-Command chrome -ErrorAction SilentlyContinue) {
        Start-Process chrome "http://127.0.0.1:$Port"
    } else {
        Start-Process "http://127.0.0.1:$Port"
    }
}

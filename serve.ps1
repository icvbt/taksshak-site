param([int]$Port = 8099)
$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$py = $null
$cmd = Get-Command python -ErrorAction SilentlyContinue
if ($cmd) { $py = $cmd.Source }
if (-not $py) { $py = 'C:\Users\Lenovo\AppData\Local\Programs\Python\Python313\python.exe' }
if (-not (Test-Path -LiteralPath $py)) { throw "Python not found. Install Python or edit `$py in serve.ps1." }
Write-Host "Serving offline clone from $root"
Write-Host "Open: http://127.0.0.1:$Port/index.html"
& $py -m http.server $Port --bind 127.0.0.1 --directory $root

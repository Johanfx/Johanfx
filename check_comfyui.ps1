# Diagnostico de ComfyUI: GPU, nodos y modelos. Uso: clic derecho > Ejecutar con PowerShell
# (o: powershell -ExecutionPolicy Bypass -File check_comfyui.ps1 -Path "C:\ruta\ComfyUI")
param([string]$Path = "")
Write-Host "== GPU ==" -ForegroundColor Cyan
try { nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv,noheader } catch { Write-Host "nvidia-smi no encontrado (drivers NVIDIA?)" -ForegroundColor Red }

if (-not $Path) {
  $cands = @("$PSScriptRoot\ComfyUI","$env:USERPROFILE\ComfyUI","$env:USERPROFILE\Documents\ComfyUI","C:\ComfyUI","$env:USERPROFILE\Desktop\ComfyUI","D:\ComfyUI")
  $Path = $cands | Where-Object { Test-Path "$_\main.py" } | Select-Object -First 1
}
if (-not $Path -or -not (Test-Path "$Path\main.py")) { Write-Host "No encuentro ComfyUI. Pasa -Path con su carpeta." -ForegroundColor Red; exit 1 }
Write-Host "`nComfyUI en: $Path" -ForegroundColor Green

Write-Host "`n== Nodos (custom_nodes) ==" -ForegroundColor Cyan
Get-ChildItem "$Path\custom_nodes" -Directory | ForEach-Object { $_.Name }

Write-Host "`n== Modelos (>100MB) ==" -ForegroundColor Cyan
Get-ChildItem "$Path\models" -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Length -gt 100MB } |
  ForEach-Object { "{0,-70} {1,8:N1} GB" -f $_.FullName.Replace("$Path\models\",""), ($_.Length/1GB) }

Write-Host "`n== Buscando los que mencionaste ==" -ForegroundColor Cyan
foreach ($k in "minimax","hailuo","yue","qwen") {
  $hit = Get-ChildItem $Path -Recurse -ErrorAction SilentlyContinue -Include "*$k*" | Select-Object -First 3
  if ($hit) { Write-Host "[OK]  $k" -ForegroundColor Green; $hit | ForEach-Object { "      $($_.FullName)" } } else { Write-Host "[NO]  $k" -ForegroundColor Yellow }
}
Write-Host "`nPega esta salida en el chat y te digo que falta o esta mal."
Read-Host "Enter para salir"

$ErrorActionPreference = 'Stop'

$Root = Split-Path -Parent $PSScriptRoot
$AudioDir = Join-Path $Root 'audio'
$VocalDir = Join-Path $Root 'build\vocal'
$Music = Join-Path $AudioDir 'neon-afterglow-synthwave.mp3'
$Output = Join-Path $AudioDir 'neon-afterglow-vocal.mp3'

New-Item -ItemType Directory -Force $AudioDir | Out-Null
powershell.exe -NoProfile -ExecutionPolicy Bypass -File (Join-Path $PSScriptRoot 'generate_vocal.ps1')

$phraseFiles = @(
  '01-neon-afterglow.wav',
  '02-running-through-the-night.wav',
  '03-city-lights.wav',
  '04-neon-afterglow.wav',
  '05-dont-look-back.wav',
  '06-city-lights.wav',
  '07-neon-afterglow.wav'
) | ForEach-Object { Join-Path $VocalDir $_ }

$delays = @(12000, 32000, 58000, 78000, 118000, 138000, 168000)
$filters = @('[0:a]volume=0.86[music]')
$labels = @()
for ($i = 0; $i -lt $phraseFiles.Count; $i++) {
  $label = "v$i"
  $labels += "[$label]"
  $delay = $delays[$i]
  $filters += "[$($i + 1):a]aformat=sample_fmts=fltp:sample_rates=44100:channel_layouts=stereo,adelay=${delay}|${delay},aecho=0.8:0.82:620|1120:0.28|0.16,highpass=f=120,lowpass=f=9000,acompressor=threshold=-18dB:ratio=3:attack=12:release=180:makeup=2,volume=0.58,apad=whole_dur=180[$label]"
}
$filters += "[music]$($labels -join '')amix=inputs=8:duration=first:dropout_transition=0:normalize=0,loudnorm=I=-14:TP=-1.0:LRA=7[out]"
$filterPath = Join-Path $Root 'build\vocal-filter.txt'
[System.IO.File]::WriteAllLines($filterPath, ($filters -join ';'))

$args = @('-hide_banner','-loglevel','warning','-y','-i',$Music)
foreach ($file in $phraseFiles) { $args += @('-i',$file) }
$args += @('-filter_complex_script',$filterPath,'-map','[out]','-c:a','libmp3lame','-b:a','192k','-ar','44100','-ac','2',$Output)
& ffmpeg @args
if ($LASTEXITCODE -ne 0) { throw 'Failed to mix vocal audio' }

Write-Output "Rendered $Output"

param(
  [string]$AudioFile = 'audio\neon-afterglow-synthwave.mp3',
  [string]$OutputFile = 'output\neon-afterglow-mv.mp4'
)
$ErrorActionPreference = 'Stop'

$Root = Split-Path -Parent $PSScriptRoot
$Build = Join-Path $Root 'build'
$Assets = Join-Path $Root 'assets'
$Audio = Join-Path $Root $AudioFile
$OutputDir = Join-Path $Root 'output'
$Output = Join-Path $Root $OutputFile

New-Item -ItemType Directory -Force $Build, $OutputDir | Out-Null

$normalization = @(
  @{ Source = '01-city-walk.mp4'; Out = 'norm01.mp4' },
  @{ Source = '02-rainy-neon-reflections.mp4'; Out = 'norm02.mp4' },
  @{ Source = '03-elevated-train.mp4'; Out = 'norm03.mp4' },
  @{ Source = '04-city-overlook.mp4'; Out = 'norm04.mp4' },
  @{ Source = '06-rainy-timelapse.mp4'; Out = 'norm06.mp4' },
  @{ Source = '07-traffic-bokeh.mp4'; Out = 'norm07.mp4' },
  @{ Source = '08-traffic-light-trails.mp4'; Out = 'norm08.mp4' },
  @{ Source = '10-bridge-cityscape.mp4'; Out = 'norm10.mp4' },
  @{ Source = '11-street-lamp.mp4'; Out = 'norm11.mp4' },
  @{ Source = '12-skyline.mp4'; Out = 'norm12.mp4' },
  @{ Source = '13-city-timelapse.mp4'; Out = 'norm13.mp4' },
  @{ Source = '14-colorful-street.mp4'; Out = 'norm14.mp4' },
  @{ Source = '15-long-city-train.mp4'; Out = 'norm15.mp4' },
  @{ Source = '16-city-dusk-walk.mp4'; Out = 'norm16.mp4' },
  @{ Source = '17-city-train-later.mp4'; Out = 'norm17.mp4' },
  @{ Source = '18-city-train-final.mp4'; Out = 'norm18.mp4' }
)

foreach ($item in $normalization) {
  $source = Join-Path $Assets $item.Source
  $out = Join-Path $Build $item.Out
  & ffmpeg -hide_banner -loglevel warning -y -i $source `
    -vf 'fps=30,format=yuv420p' -an -c:v libx264 -preset fast -crf 23 -movflags +faststart $out
  if ($LASTEXITCODE -ne 0) { throw "Failed to normalize $source" }
}

$plans = @(
  @{ Name = 'part1'; Order = @('norm16.mp4','norm01.mp4','norm11.mp4','norm12.mp4','norm06.mp4','norm10.mp4','norm08.mp4'); Filter = 'scale=1280:720,fps=30,format=yuv420p' },
  @{ Name = 'part2'; Order = @('norm15.mp4','norm02.mp4','norm07.mp4','norm03.mp4','norm13.mp4','norm14.mp4'); Filter = 'scale=1280:720,fps=30,eq=contrast=1.08:brightness=-0.02:saturation=1.20,format=yuv420p' },
  @{ Name = 'part3'; Order = @('norm17.mp4','norm04.mp4','norm18.mp4'); Filter = 'scale=1280:720,fps=30,hue=h=8:s=1.15,eq=contrast=1.05:brightness=-0.01,tpad=stop_mode=clone:stop_duration=3,trim=duration=60,format=yuv420p' }
)

$partFiles = @()
foreach ($plan in $plans) {
  $listPath = Join-Path $Build "$($plan.Name).txt"
  $lines = foreach ($name in $plan.Order) {
    $path = (Join-Path $Build $name).Replace('\', '/')
    "file '$path'"
  }
  [System.IO.File]::WriteAllLines($listPath, $lines)

  $partPath = Join-Path $Build "$($plan.Name).mp4"
  & ffmpeg -hide_banner -loglevel warning -y -f concat -safe 0 -i $listPath -t 60 `
    -vf $plan.Filter -an -c:v libx264 -preset fast -crf 23 -movflags +faststart $partPath
  if ($LASTEXITCODE -ne 0) { throw "Failed to render $($plan.Name)" }
  $partFiles += $partPath
}

$font = 'C\:/Windows/Fonts/arial.ttf'
$vf = "[0:v][1:v][2:v]concat=n=3:v=1:a=0,format=yuv420p,drawtext=fontfile='$font':text='NEON AFTERGLOW':fontcolor=white:fontsize=52:x=(w-text_w)/2:y=h*0.40:enable='between(t,1,6)':alpha='if(lt(t,2),t-1,if(gt(t,5),6-t,1))',drawtext=fontfile='$font':text='A SYNTHWAVE MUSIC VIDEO':fontcolor=white@0.78:fontsize=20:x=(w-text_w)/2:y=h*0.52:enable='between(t,2,6)',drawtext=fontfile='$font':text='NANJING UNIVERSITY  |  INTELLIGENT SPEECH TECHNOLOGY  |  HOMEWORK 2':fontcolor=white@0.88:fontsize=18:x=(w-text_w)/2:y=h*0.86:enable='between(t,173,179.8)'[v]"

& ffmpeg -hide_banner -loglevel warning -y -i $partFiles[0] -i $partFiles[1] -i $partFiles[2] -i $Audio `
  -filter_complex $vf -map '[v]' -map 3:a:0 -t 180 `
  -c:v libx264 -preset medium -crf 21 -pix_fmt yuv420p -r 30 `
  -c:a aac -b:a 192k -ar 44100 -ac 2 -movflags +faststart `
  -metadata title='Neon Afterglow MV' `
  -metadata comment='Nanjing University Intelligent Speech Technology Homework 2' $Output
if ($LASTEXITCODE -ne 0) { throw 'Failed to render final MV' }

Write-Output "Rendered $Output"

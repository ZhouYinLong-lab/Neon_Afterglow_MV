$ErrorActionPreference = 'Stop'

$Root = Split-Path -Parent $PSScriptRoot
$VocalDir = Join-Path $Root 'build\vocal'
New-Item -ItemType Directory -Force $VocalDir | Out-Null

Add-Type -AssemblyName System.Speech
$voice = New-Object System.Speech.Synthesis.SpeechSynthesizer
$voice.SelectVoice('Microsoft Zira Desktop')
$voice.Rate = -1
$voice.Volume = 92

$lines = @(
  @{ Name = '01-neon-afterglow'; Text = 'Neon afterglow.' },
  @{ Name = '02-running-through-the-night'; Text = 'Running through the night.' },
  @{ Name = '03-city-lights'; Text = 'We are alive in the city lights.' },
  @{ Name = '04-neon-afterglow'; Text = 'Neon afterglow.' },
  @{ Name = '05-dont-look-back'; Text = 'Do not look back.' },
  @{ Name = '06-city-lights'; Text = 'We are alive in the city lights.' },
  @{ Name = '07-neon-afterglow'; Text = 'Neon afterglow.' }
)

foreach ($line in $lines) {
  $out = Join-Path $VocalDir "$($line.Name).wav"
  $voice.SetOutputToWaveFile($out)
  $voice.Speak($line.Text)
  $voice.SetOutputToNull()
}

$voice.Dispose()
Write-Output "Generated $($lines.Count) vocal phrases in $VocalDir"

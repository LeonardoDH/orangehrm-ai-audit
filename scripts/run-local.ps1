param([ValidateSet('pipeline','explore','automate','review')][string]$Stage = 'pipeline')
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location -LiteralPath $repoRoot
if (!$env:GITHUB_REPOSITORY) { $env:GITHUB_REPOSITORY = 'LeonardoDH/orangehrm-ai-audit' }
$owner = $env:GITHUB_REPOSITORY.Split('/')[0]
$previousToken = $env:GITHUB_TOKEN
try {
  if (!$env:GITHUB_TOKEN) {
    $credentialLines = "protocol=https`nhost=github.com`nusername=$owner`n`n" | git credential fill
    if ($LASTEXITCODE -ne 0) { throw 'Git credential manager could not supply a credential. Set GITHUB_TOKEN.' }
    foreach ($line in $credentialLines) {
      if ($line -match '^password=(.*)$') { $env:GITHUB_TOKEN = $matches[1] }
    }
    if (!$env:GITHUB_TOKEN) { throw 'Missing GitHub credential' }
  }
  node src/cli.js $Stage --publish
  if ($LASTEXITCODE -ne 0) { throw "Stage $Stage failed" }
} finally {
  if ($previousToken) { $env:GITHUB_TOKEN = $previousToken } else { Remove-Item Env:GITHUB_TOKEN -ErrorAction SilentlyContinue }
}

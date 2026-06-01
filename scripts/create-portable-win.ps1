$ErrorActionPreference = "Stop"

$appName = "ruli-smile-cleaner"
$buildDir = "build\stable-win-x64"
$bundleDir = Join-Path $buildDir $appName
$portableRoot = "build\portable"
$portableApp = Join-Path $portableRoot "app"
$extractDir = "build\portable-extract"
$zstd = "node_modules\electrobun\dist-win-x64\zig-zstd.exe"
$portableZip = "build\ruli-smile-cleaner-portable-win-x64.zip"

Remove-Item -Recurse -Force $portableRoot, $extractDir -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force $portableApp, $extractDir | Out-Null

$innerArchive = Get-ChildItem (Join-Path $bundleDir "Resources\*.tar.zst") | Select-Object -First 1
if ($null -eq $innerArchive) {
  throw "Electrobun inner app archive was not found."
}

& $zstd decompress -i $innerArchive.FullName -o (Join-Path $extractDir "app.tar")
tar -xf (Join-Path $extractDir "app.tar") -C $extractDir

$appBundle = Get-ChildItem $extractDir -Directory -Recurse |
  Where-Object {
    (Test-Path (Join-Path $_.FullName "bin")) -and
    (Test-Path (Join-Path $_.FullName "Resources"))
  } |
  Sort-Object { $_.FullName.Length } |
  Select-Object -First 1

if ($null -eq $appBundle) {
  throw "Extracted Electrobun app bundle was not found."
}

Move-Item (Join-Path $appBundle.FullName "bin") (Join-Path $portableApp "bin")
Move-Item (Join-Path $appBundle.FullName "Resources") (Join-Path $portableApp "Resources")

$launcher = Join-Path $portableApp "bin\launcher.exe"
if (!(Test-Path $launcher)) {
  $launcherWithoutExt = Join-Path $portableApp "bin\launcher"
  if (Test-Path $launcherWithoutExt) {
    Rename-Item -Path $launcherWithoutExt -NewName "launcher.exe"
  } else {
    throw "launcher.exe was not found in portable app bundle."
  }
}

@'
@echo off
cd /d "%~dp0app\bin"
start "" "launcher.exe"
'@ | Set-Content -Encoding ASCII (Join-Path $portableRoot "황달클리너_실행.bat")

if (Test-Path $portableZip) {
  Remove-Item -Force $portableZip
}
Compress-Archive -Path (Join-Path $portableRoot "*") -DestinationPath $portableZip -Force

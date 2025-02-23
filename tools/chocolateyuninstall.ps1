$ErrorActionPreference = 'Stop'

$unzipLocation = Join-Path -Path (Get-ToolsLocation) -ChildPath $env:ChocolateyPackageName
Remove-Item -Path $unzipLocation -Recurse -Force -ErrorAction SilentlyContinue

$linkName = 'OpenRGB.lnk'

$programsDirectory = [Environment]::GetFolderPath([Environment+SpecialFolder]::Programs)
$programsShortcutFilePath = Join-Path -Path $programsDirectory -ChildPath $linkName
if (Test-Path $programsShortcutFilePath) {
  Remove-Item $programsShortcutFilePath
}

$desktopDirectory = [Environment]::GetFolderPath([Environment+SpecialFolder]::DesktopDirectory)
$desktopShortcutFilePath = Join-Path -Path $desktopDirectory -ChildPath $linkName
if (Test-Path $desktopShortcutFilePath) {
  Remove-Item $desktopShortcutFilePath
}

Uninstall-BinFile -Name 'OpenRGB'

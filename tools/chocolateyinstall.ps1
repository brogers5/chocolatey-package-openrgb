$ErrorActionPreference = 'Stop'

$archiveFileNames = @('OpenRGB_1.0rc1_Windows_64_1fbacde.zip', 'OpenRGB_1.0rc1_Windows_32_1fbacde.zip')

if ((Get-OSArchitectureWidth -Compare 64) -and ($env:chocolateyForceX86 -ne $true)) {
  $extractedArchiveName = $archiveFileNames[0]
  $archiveDirectory = 'OpenRGB Windows 64-bit'
}
else {
  $extractedArchiveName = $archiveFileNames[1]
  $archiveDirectory = 'OpenRGB Windows 32-bit'
}
$toolsDirectory = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$extractedArchivePath = Join-Path -Path $toolsDirectory -ChildPath $extractedArchiveName
$unzipLocation = Join-Path -Path (Get-ToolsLocation) -ChildPath $env:ChocolateyPackageName

$packageArgs = @{
  fileFullPath = $extractedArchivePath
  destination  = $unzipLocation
  packageName  = $env:ChocolateyPackageName
}
Get-ChocolateyUnzip @packageArgs

#Clean up ZIP archives post-extraction to prevent unnecessary disk bloat
foreach ($archiveFileName in $archiveFileNames) {
  $archiveFilePath = Join-Path -Path $toolsDirectory -ChildPath $archiveFileName
  Remove-Item -Path $archiveFilePath -Force -ErrorAction SilentlyContinue
}

$softwareName = 'OpenRGB'
$binaryFileName = 'OpenRGB.exe'
$linkName = "$softwareName.lnk"
$targetPath = Join-Path -Path $unzipLocation -ChildPath $archiveDirectory | Join-Path -ChildPath $binaryFileName

$pp = Get-PackageParameters

if ($pp.NoShim) {
  Uninstall-BinFile -Name $softwareName
}
else {
  Install-BinFile -Name $softwareName -Path $targetPath
}

if (!$pp.NoDesktopShortcut) {
  $desktopDirectory = [Environment]::GetFolderPath([Environment+SpecialFolder]::DesktopDirectory)
  $shortcutFilePath = Join-Path -Path $desktopDirectory -ChildPath $linkName
  Install-ChocolateyShortcut -ShortcutFilePath $shortcutFilePath -TargetPath $targetPath -ErrorAction SilentlyContinue
}

if (!$pp.NoProgramsShortcut) {
  $programsDirectory = [Environment]::GetFolderPath([Environment+SpecialFolder]::Programs)
  $shortcutFilePath = Join-Path -Path $programsDirectory -ChildPath $linkName
  Install-ChocolateyShortcut -ShortcutFilePath $shortcutFilePath -TargetPath $targetPath -ErrorAction SilentlyContinue
}

if ($pp.Start) {
  try {
    #Spawn a separate temporary PowerShell instance to prevent display of console output
    $statement = "Start-Process -FilePath ""$targetPath"""
    Start-ChocolateyProcessAsAdmin -Statements $statement -NoSleep -ErrorAction SilentlyContinue
  }
  catch {
    Write-Warning "$softwareName failed to start, please try to manually start it instead."
  }
}

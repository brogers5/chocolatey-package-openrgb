$ErrorActionPreference = 'Stop'

$archiveFileNames = @('OpenRGB_0.7_Windows_64_6128731.zip', 'OpenRGB_0.7_Windows_32_6128731.zip')

if ((Get-OSArchitectureWidth -Compare 64) -and ($env:chocolateyForceX86 -ne $true))
{
  $extractedArchiveName = $archiveFileNames[0]
  $archiveDirectory     = 'OpenRGB Windows 64-bit'
}
else
{
  $extractedArchiveName = $archiveFileNames[1]
  $archiveDirectory     = 'OpenRGB Windows 32-bit'
}
$toolsDirectory = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$extractedArchivePath = Join-Path -Path $toolsDirectory -ChildPath $extractedArchiveName

$packageArgs = @{
  fileFullPath   = $extractedArchivePath
  destination    = $toolsDirectory
  packageName    = $env:ChocolateyPackageName
}
Get-ChocolateyUnzip @packageArgs

#Clean up ZIP archives post-extraction to prevent unnecessary disk bloat
foreach ($archiveFileName in $archiveFileNames)
{
  $archiveFilePath = Join-Path -Path $toolsDirectory -ChildPath $archiveFileName
  Remove-Item -Path $archiveFilePath -Force -ErrorAction SilentlyContinue
}

$softwareName = 'OpenRGB'
$binaryFileName = 'OpenRGB.exe'
$linkName = "$softwareName.lnk"
$targetPath = Join-Path -Path $toolsDirectory -ChildPath $archiveDirectory | Join-Path -ChildPath $binaryFileName

$pp = Get-PackageParameters
if ($pp.NoShim)
{
  #Create shim ignore file
  $ignoreFilePath = Join-Path -Path $toolsDirectory -ChildPath $archiveDirectory | Join-Path -ChildPath "$binaryFileName.ignore"
  Set-Content -Path $ignoreFilePath -Value $null -ErrorAction SilentlyContinue
}

if (!$pp.NoDesktopShortcut)
{
  $desktopDirectory = [Environment]::GetFolderPath([Environment+SpecialFolder]::DesktopDirectory)
  $shortcutFilePath = Join-Path -Path $desktopDirectory -ChildPath $linkName
  Install-ChocolateyShortcut -ShortcutFilePath $shortcutFilePath -TargetPath $targetPath -ErrorAction SilentlyContinue
}

if (!$pp.NoProgramsShortcut)
{
  $programsDirectory = [Environment]::GetFolderPath([Environment+SpecialFolder]::Programs)
  $shortcutFilePath = Join-Path -Path $programsDirectory -ChildPath $linkName
  Install-ChocolateyShortcut -ShortcutFilePath $shortcutFilePath -TargetPath $targetPath -ErrorAction SilentlyContinue
}

if ($pp.Start)
{
  try
  {
    Start-Process -FilePath $targetPath -ErrorAction Continue
  }
  catch
  {
    Write-Warning "$softwareName failed to start, please try to manually start it instead."
  }
}

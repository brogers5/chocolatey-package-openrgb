$ErrorActionPreference = 'Stop'

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition)
. $currentPath\helpers.ps1

$nuspecFileRelativePath = Join-Path -Path $currentPath -ChildPath 'openrgb.nuspec'
[xml] $nuspec = Get-Content $nuspecFileRelativePath
$version = [Version] $nuspec.package.metadata.version
$downloadUris = Get-DownloadUris -Version $version

$global:Latest = @{
    Url32 = $downloadUris.Url32
    Url64 = $downloadUris.Url64
}

Write-Output "Downloading..."
Get-RemoteFiles -Purge -NoSuffix

Write-Output "Creating package..."
choco pack $nuspecFileRelativePath

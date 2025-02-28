[CmdletBinding()]
param($IncludeStream, [switch] $Force)
Import-Module au

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition)
. $currentPath\helpers.ps1

$softwareRepo = 'CalcProgrammer1/OpenRGB'

function global:au_GetLatest {
    $streams = [ordered] @{
        ReleaseCandidate = Get-LatestReleaseCandidateVersionInfo
        Stable           = Get-LatestStableVersionInfo
    }

    return @{ Streams = $streams }
}

function global:au_BeforeUpdate ($Package) {
    Set-DescriptionFromReadme -Package $Package -ReadmePath '.\DESCRIPTION.md'
}

function global:au_SearchReplace {
    @{
        "$($Latest.PackageName).nuspec" = @{
            '(<packageSourceUrl>)[^<]*(</packageSourceUrl>)'                             = "`$1https://github.com/brogers5/chocolatey-package-$($Latest.PackageName)/tree/v$($Latest.Version)`$2"
            '(<licenseUrl>)[^<]*(</licenseUrl>)'                                         = "`$1https://gitlab.com/$($softwareRepo)/-/blob/$($Latest.Tag)/LICENSE`$2"
            '(<projectSourceUrl>)[^<]*(</projectSourceUrl>)'                             = "`$1https://gitlab.com/$($softwareRepo)/-/tree/$($Latest.Tag)`$2"
            '(<releaseNotes>)[^<]*(</releaseNotes>)'                                     = "`$1https://gitlab.com/$($softwareRepo)/-/releases/$($Latest.Tag)`$2"
            '(<copyright>)[^<]*(</copyright>)'                                           = "`$1Copyright (C) $(Get-Date -Format yyyy) Adam Honse`$2"
            "(\<dependency .+?`"$($Latest.PackageName).portable`" version=)`"([^`"]+)`"" = "`$1`"[$($Latest.Version)]`""
        }
    }
}

Update-Package -ChecksumFor None -IncludeStream $IncludeStream -Force:$Force -NoReadme

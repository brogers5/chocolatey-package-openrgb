Import-Module au

$currentPath = (Split-Path $MyInvocation.MyCommand.Definition)
. $currentPath\helpers.ps1

$toolsPath = Join-Path -Path $currentPath -ChildPath 'tools'
$softwareRepo = 'CalcProgrammer1/OpenRGB'

function global:au_GetLatest {
    $latestInfo = Get-LatestVersionInfo
    $script:softwareTag = Get-TagName -Version ([Version] $latestInfo.Version)

    return $latestInfo
}

function global:au_BeforeUpdate ($Package)  {
    Get-RemoteFiles -Purge -NoSuffix -Algorithm sha256

    $templateFilePath = Join-Path -Path $toolsPath -ChildPath 'VERIFICATION.txt.template'
    $verificationFilePath = Join-Path -Path $toolsPath -ChildPath 'VERIFICATION.txt'
    Copy-Item -Path $templateFilePath -Destination $verificationFilePath -Force

    Set-DescriptionFromReadme -Package $Package -ReadmePath ".\DESCRIPTION.md"
}

function global:au_AfterUpdate ($Package)  {
    $licenseUri = "https://gitlab.com/$($softwareRepo)/-/raw/$($softwareTag)/LICENSE"
    $licenseContents = Invoke-WebRequest -Uri $licenseUri -UseBasicParsing

    $licensePath = Join-Path -Path $toolsPath -ChildPath 'LICENSE.txt'
    Set-Content -Path $licensePath -Value "From: $licenseUri`r`n`r`n$licenseContents"

    #Archive the current source code to prepare for possible redistribution requests, as required by GPLv2
    Get-SourceCode -Version [Version] $($Latest.Version)
}

function global:au_SearchReplace {
    @{
        "$($Latest.PackageName).nuspec" = @{
            "<packageSourceUrl>[^<]*</packageSourceUrl>" = "<packageSourceUrl>https://github.com/brogers5/chocolatey-package-$($Latest.PackageName)/tree/v$($Latest.Version)</packageSourceUrl>"
            "<licenseUrl>[^<]*</licenseUrl>" = "<licenseUrl>https://gitlab.com/$($softwareRepo)/-/blob/$($softwareTag)/LICENSE</licenseUrl>"
            "<projectSourceUrl>[^<]*</projectSourceUrl>" = "<projectSourceUrl>https://gitlab.com/$($softwareRepo)/-/tree/$($softwareTag)</projectSourceUrl>"
            "<releaseNotes>[^<]*</releaseNotes>" = "<releaseNotes>https://gitlab.com/$($softwareRepo)/-/releases/$($softwareTag)</releaseNotes>"
            "<copyright>[^<]*</copyright>" = "<copyright>Copyright (C) $(Get-Date -Format yyyy) Adam Honse</copyright>"
        }
        'tools\VERIFICATION.txt' = @{
            '%url32%' = "$($Latest.Url32)"
            '%url64%' = "$($Latest.Url64)"
            '%checksumType%' = "$($Latest.ChecksumType32.ToUpper())"
            '%file32%' = "$($Latest.FileName32)"
            '%checksum32%' = "$($Latest.Checksum32)"
            '%file64%' = "$($Latest.FileName64)"
            '%checksum64%' = "$($Latest.Checksum64)"
        }
        'tools\chocolateyinstall.ps1' = @{
            "(^[$]archiveFileNames\s*=\s*)(.*)" = "`$1@('$($Latest.FileName64)', '$($Latest.FileName32)')"
        }
    }
}

Update-Package -ChecksumFor None -NoReadme

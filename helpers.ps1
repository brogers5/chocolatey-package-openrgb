$gitlabProjectId = 10582521
$gitLabReleasesUri = "https://gitlab.com/api/v4/projects/$gitlabProjectId/releases"
$userAgent = 'Update checker of Chocolatey Community Package ''openrgb'''

function Get-SourceCode([Version] $Version)
{
    $releaseInfoUri = Get-ReleaseUri -Version $Version
    $releaseInfo = Invoke-RestMethod -Uri $releaseInfoUri -UserAgent $userAgent -UseBasicParsing
    $assetUri = $releaseInfo.assets.sources[0].url

    Invoke-WebRequest -Uri $assetUri -UserAgent $userAgent -OutFile ".\OpenRGB-release_$Version.zip" -UseBasicParsing
}

function Get-SpecificReleaseUri([string] $TagName)
{
    return "$gitLabReleasesUri/$tagName"
}

function Get-ReleaseUri([Version] $Version)
{
    if ($null -eq $Version)
    {
        # Default to latest release
        $releases = Invoke-RestMethod -Uri $gitLabReleasesUri -UserAgent $userAgent -UseBasicParsing
        $tagName = $releases[0].tag_name
    }
    else 
    {
        $tagName = Get-TagName -Version $Version
    }

    return Get-SpecificReleaseUri -TagName $tagName 
}

function Get-TagName([Version] $Version)
{
    return "release_$($Version.Major).$($Version.Minor)"
}

function Get-Version([string] $TagName)
{
    return [Version] $TagName.TrimStart('release_')
}

function Get-RelevantReleaseInfo($ReleaseInfo, [string] $ReleaseUri)
{
    if ($null -eq $ReleaseInfo)
    {
        $ReleaseInfo = Invoke-RestMethod -Uri $ReleaseUri -UserAgent $userAgent -UseBasicParsing
    }
    $tagName = $ReleaseInfo.tag_name

    return @{
        CommitShortId = $ReleaseInfo.commit.short_id.Substring(0, 7)
        TagName = $tagName
        Version = Get-Version -TagName $tagName
    }
}

function Get-DownloadUris($RelevantReleaseInfo, [Version] $Version, [string] $ReleaseUri)
{
    if ($null -ne $RelevantReleaseInfo)
    {
        if ([uri]::IsWellFormedUriString($ReleaseUri, 'Absolute'))
        {`
            $RelevantReleaseInfo = Get-RelevantReleaseInfo -ReleaseUri $releaseUri
        }
        elseif ($null -ne $Version)
        {
            #TODO: Map any package fix versions to underlying software version


            $tagName = Get-TagName -Version $Version
            $ReleaseUri = Get-SpecificReleaseUri -TagName $tagName 
            $RelevantReleaseInfo = Get-ReleaseInfo -ReleaseUri $releaseUri
        }
    }

    return @{
        Url32 = "https://openrgb.org/releases/$($RelevantReleaseInfo.TagName)/OpenRGB_$($RelevantReleaseInfo.Version.ToString(2))_Windows_32_$($RelevantReleaseInfo.CommitShortId).zip"
        Url64 = "https://openrgb.org/releases/$($RelevantReleaseInfo.TagName)/OpenRGB_$($RelevantReleaseInfo.Version.ToString(2))_Windows_64_$($RelevantReleaseInfo.CommitShortId).zip"
    }
}

function Get-LatestVersionInfo
{
    $releasesInfo = Invoke-RestMethod -Uri $gitLabReleasesUri -UserAgent $userAgent -UseBasicParsing
    $latestReleaseInfo = $releasesInfo[0]
    $relevantReleaseInfo = Get-RelevantReleaseInfo -ReleaseInfo $latestReleaseInfo
    $downloadUris = Get-DownloadUris -RelevantReleaseInfo $relevantReleaseInfo

    return @{
        Url32   = $downloadUris.Url32
        Url64   = $downloadUris.Url64
        Version = $relevantReleaseInfo.Version.ToString(2)
    }
}

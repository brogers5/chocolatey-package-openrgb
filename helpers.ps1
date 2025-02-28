$gitlabProjectId = 10582521
$gitLabReleasesUri = "https://gitlab.com/api/v4/projects/$gitlabProjectId/releases"
$userAgent = 'Update checker of Chocolatey Community Package ''openrgb'''

function Get-SpecificReleaseInfoUri([string] $TagName) {
    return "$gitLabReleasesUri/$tagName"
}

function Get-TagName([semver] $Version) {
    if ([string]::IsNullOrEmpty($Version.PreReleaseLabel)) {
        $tagName = "release_$($Version.Major).$($Version.Minor)"
    }
    else {
        $tagName = "release_candidate_$($Version.Major).$($Version.Minor)$($Version.PreReleaseLabel)"
    }
    
    return $tagName
}

function Get-RawVersion([string] $TagName) {
    return $TagName.TrimStart('release_').TrimStart('candidate_')
}

function Get-SemanticVersion([string] $TagName) {
    return [semver] ((Get-RawVersion -TagName $TagName) -replace '(\d)(rc\d+)', "`$1-`$2")
}

function Get-RelevantReleaseInfo($ReleaseInfo, [string] $ReleaseUri) {
    if ($null -eq $ReleaseInfo) {
        $ReleaseInfo = Invoke-RestMethod -Uri $ReleaseUri -UserAgent $userAgent -UseBasicParsing
    }
    $tagName = $ReleaseInfo.tag_name

    return @{
        CommitShortId = $ReleaseInfo.commit.short_id.Substring(0, 7)
        RawVersion    = Get-RawVersion -TagName $tagName
        TagName       = $tagName
        Version       = Get-SemanticVersion -TagName $tagName
    }
}

function Get-DownloadUris($RelevantReleaseInfo, [semver] $Version) {
    if ($null -eq $RelevantReleaseInfo -and $null -ne $Version) {
        #TODO: Map any package fix versions to underlying software version

        $tagName = Get-TagName -Version $Version
        $releaseUri = Get-SpecificReleaseInfoUri -TagName $tagName
        $RelevantReleaseInfo = Get-RelevantReleaseInfo -ReleaseUri $releaseUri
    }

    return @{
        Url32 = "https://openrgb.org/releases/$($RelevantReleaseInfo.TagName)/OpenRGB_$($RelevantReleaseInfo.RawVersion)_Windows_32_$($RelevantReleaseInfo.CommitShortId).zip"
        Url64 = "https://openrgb.org/releases/$($RelevantReleaseInfo.TagName)/OpenRGB_$($RelevantReleaseInfo.RawVersion)_Windows_64_$($RelevantReleaseInfo.CommitShortId).zip"
    }
}

function Get-LatestStableVersionInfo {
    $releasesInfo = Invoke-RestMethod -Uri $gitLabReleasesUri -UserAgent $userAgent -UseBasicParsing
    $latestReleaseInfo = $releasesInfo | Where-Object { $_.name -match 'release_\d\.\d+' } | Select-Object -First 1
    $relevantReleaseInfo = Get-RelevantReleaseInfo -ReleaseInfo $latestReleaseInfo
    $downloadUris = Get-DownloadUris -RelevantReleaseInfo $relevantReleaseInfo

    return @{
        SoftwareVersion = $relevantReleaseInfo.RawVersion
        Tag             = $relevantReleaseInfo.TagName
        Url32           = $downloadUris.Url32
        Url64           = $downloadUris.Url64
        Version         = $relevantReleaseInfo.Version.ToString() #This may change if building a package fix version
    }
}

function Get-LatestReleaseCandidateVersionInfo {
    $releasesInfo = Invoke-RestMethod -Uri $gitLabReleasesUri -UserAgent $userAgent -UseBasicParsing
    $latestReleaseInfo = $releasesInfo | Where-Object { $_.tag_name -match 'release_candidate_\d\.\d+rc\d+' } | Select-Object -First 1
    $relevantReleaseInfo = Get-RelevantReleaseInfo -ReleaseInfo $latestReleaseInfo
    $downloadUris = Get-DownloadUris -RelevantReleaseInfo $relevantReleaseInfo

    return @{
        SoftwareVersion = $relevantReleaseInfo.RawVersion
        Tag             = $relevantReleaseInfo.TagName
        Url32           = $downloadUris.Url32
        Url64           = $downloadUris.Url64
        Version         = $relevantReleaseInfo.Version.ToString()  #This may change if building a package fix version
    }
}

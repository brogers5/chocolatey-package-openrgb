<!--markdownlint-disable-next-line MD033 MD045 -->
# <img src="https://cdn.jsdelivr.net/gh/brogers5/chocolatey-package-openrgb@dd76d83044a6045e1882e53a7360fb8791811de5/openrgb.png" width="48" height="48" alt="OpenRGB icon"/> Chocolatey Package: [OpenRGB](https://community.chocolatey.org/packages/openrgb)

[![Latest package version shield](https://img.shields.io/chocolatey/v/openrgb.svg?include_prereleases)](https://community.chocolatey.org/packages/openrgb)
[![Total package download count shield](https://img.shields.io/chocolatey/dt/openrgb.svg)](https://community.chocolatey.org/packages/openrgb)

---

This package is part of a family of packages published for OpenRGB. This repository is for the meta package.

* For the installer package, see [chocolatey-package-openrgb.install](https://github.com/brogers5/chocolatey-package-openrgb.install).
* For the portable package, see [chocolatey-package-openrgb.portable](https://github.com/brogers5/chocolatey-package-openrgb.portable).

See the [Chocolatey FAQs](https://docs.chocolatey.org/en-us/faqs) for more information on [meta packages](https://docs.chocolatey.org/en-us/faqs/#what-is-the-difference-between-packages-no-suffix-as-compared-to-install-portable) and [installer/portable packages](https://docs.chocolatey.org/en-us/faqs#what-distinction-does-chocolatey-make-between-an-installable-and-a-portable-application).

---

## Install

[Install Chocolatey](https://chocolatey.org/install), and run the following command to install the latest approved stable version from the Chocolatey Community Repository:

```shell
choco install openrgb --source="'https://community.chocolatey.org/api/v2'"
```

Alternatively, the packages as published on the Chocolatey Community Repository will also be mirrored on this repository's [Releases page](https://github.com/brogers5/chocolatey-package-openrgb/releases). The `nupkg` can be installed from the current directory (with dependencies sourced from the Community Repository) as follows:

```shell
choco install openrgb --source="'.;https://community.chocolatey.org/api/v2/'"
```

This package also supports the project's Release Candidate builds. Opt into these with the `--prerelease` switch.

## Build

[Install Chocolatey](https://chocolatey.org/install), clone this repository, and run the following command in the cloned repository:

```shell
choco pack
```

A successful build will create `openrgb.x.y.z.nupkg`, where `x.y.z` should be the Nuspec's normalized `version` value at build time.

>[!Note]
>As of Chocolatey v2.0.0, `version` values are normalized to contain a [SemVer 2.0.0](https://semver.org/spec/v2.0.0.html)-compliant patch number (i.e. only 2 segments will no longer be honored). Legacy package versions that did not contain these will be padded with a patch number of 0. Going forward, `version` will be padded accordingly for behavior consistency between v1 and v2 Chocolatey releases.

>[!Note]
>Chocolatey package builds are non-deterministic. Consequently, an independently built package's checksum will not match that of the officially published package.

## Update

This package should be automatically updated by the [Chocolatey Automatic Package Updater Module](https://github.com/majkinetor/au). If it is outdated by more than a few days, please [open an issue](https://github.com/brogers5/chocolatey-package-openrgb/issues).

AU expects the parent directory that contains this repository to share a name with the Nuspec (`openrgb`). Your local repository should therefore be cloned accordingly:

```shell
git clone git@github.com:brogers5/chocolatey-package-openrgb.git openrgb
```

Alternatively, a junction point can be created that points to the local repository (preferably within a repository adopting the [AU packages template](https://github.com/majkinetor/au-packages-template)):

```shell
mklink /J openrgb ..\chocolatey-package-openrgb
```

Once created, simply run `update.ps1` from within the created directory/junction point. Assuming all goes well, all relevant files should change to reflect the latest version available. This will also build a new package version using the modified files.

To limit the scope of update checks to a specific update channel, pass the `-IncludeStream` parameter with the desired Stream name:

```powershell
.\update.ps1 -IncludeStream 'Stable'
```

```powershell
.\update.ps1 -IncludeStream 'ReleaseCandidate'
```

To forcibly create an updated package (regardless of whether a new software version is available), pass the `-Force` switch:

```powershell
.\update.ps1 -Force
```

Before submitting a pull request, please [test the package](https://docs.chocolatey.org/en-us/community-repository/moderation/package-verifier#steps-for-each-package) using the latest [Chocolatey Testing Environment](https://github.com/chocolatey-community/chocolatey-test-environment) first.

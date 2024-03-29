﻿# <img src="https://cdn.jsdelivr.net/gh/brogers5/chocolatey-package-openrgb@dd76d83044a6045e1882e53a7360fb8791811de5/openrgb.png" width="48" height="48"/> Chocolatey Package: [OpenRGB](https://community.chocolatey.org/packages/openrgb)

[![Latest package version shield](https://img.shields.io/chocolatey/v/openrgb.svg)](https://community.chocolatey.org/packages/openrgb)
[![Total package download count shield](https://img.shields.io/chocolatey/dt/openrgb.svg)](https://community.chocolatey.org/packages/openrgb)

## Install

[Install Chocolatey](https://chocolatey.org/install), and run the following command to install the latest approved stable version from the Chocolatey Community Repository:

```shell
choco install openrgb --source="'https://community.chocolatey.org/api/v2'"
```

Alternatively, the packages as published on the Chocolatey Community Repository will also be mirrored on this repository's [Releases page](https://github.com/brogers5/chocolatey-package-openrgb/releases). The `nupkg` can be installed from the current directory (with dependencies sourced from the Community Repository) as follows:

```shell
choco install openrgb --source="'.;https://community.chocolatey.org/api/v2/'"
```

## Build

[Install Chocolatey](https://chocolatey.org/install), and the [Chocolatey Automatic Package Updater Module](https://github.com/majkinetor/au), then clone this repository.

Once cloned, simply run `build.ps1`. The ZIP archives are intentionally untracked to avoid bloating the repository, so the script will download the OpenRGB portable ZIP archives from the official distribution point, then packs everything together.

A successful build will create either `openrgb.x.y.nupkg` (in Chocolatey versions prior to v2.0.0) or `openrgb.x.y.0.nupkg`, where `x.y` should be the Nuspec's normalized `version` value at build time.

>**Note**
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

Before submitting a pull request, please [test the package](https://docs.chocolatey.org/en-us/community-repository/moderation/package-verifier#steps-for-each-package) using the [Chocolatey Testing Environment](https://github.com/chocolatey-community/chocolatey-test-environment) first.

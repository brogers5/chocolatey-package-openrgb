## OpenRGB

One of the biggest complaints about RGB is the software ecosystem surrounding it. Every manufacturer has their own app, their own brand, their own style. If you want to mix and match devices, you end up with a ton of conflicting, functionally identical apps competing for your background resources. On top of that, these apps are proprietary and Windows-only. Some even require online accounts. What if there was a way to control all of your RGB devices from a single app, on both Windows and Linux, without any nonsense? That is what OpenRGB sets out to achieve. One app to rule them all.

![OpenRGB Screenshot](https://cdn.jsdelivr.net/gh/brogers5/chocolatey-package-openrgb@9faeed858d7ecbb7ae71fd125e7565cf0131876d/Screenshot.png)

### Features

* Set colors and select effect modes for a wide variety of RGB hardware
* Save and load profiles
* Control lighting from third party software using the OpenRGB SDK
* Command line interface
* Connect multiple instances of OpenRGB to synchronize lighting across multiple PCs
* Can operate standalone or in a client/headless server configuration
* View device information
* No official/manufacturer software required
* Graphical view of device LEDs makes creating custom patterns easy

## Package Notes

OpenRGB has historically depended on [WinRing0](https://github.com/QCute/WinRing0), an unmaintained kernel-mode driver that has enabled the I2C and SMBus access required for interfacing with compatible graphics cards, RAM modules and motherboards. This driver contains a [known security vulnerability](https://nvd.nist.gov/vuln/detail/CVE-2021-41285), has since been included in [Microsoft's vulnerable driver blocklist](https://learn.microsoft.com/en-us/windows/security/application-security/application-control/app-control-for-business/design/microsoft-recommended-driver-block-rules#vulnerable-driver-blocklist-xml), and may be flagged by anti-malware engines as riskware.

Users are **strongly recommended** to transition to a build that uses PawnIO instead.

If you must use WinRing0 (e.g. for 32-bit OS support, legacy plugin compatibility, etc.), this may require [disabling the Microsoft vulnerable driver blocklist](https://support.microsoft.com/en-us/windows/device-security-in-the-windows-security-app-afa11526-de57-b1c5-599f-3a4c6a61c5e2#bkmk_coreisolation) and any of its upstream feature dependencies.

See [OpenRGB issue #2227](https://gitlab.com/CalcProgrammer1/OpenRGB/-/issues/2227) for more details.

---

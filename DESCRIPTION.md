
---

### [choco://openrgb](choco://openrgb)

To use choco:// protocol URLs, install [(unofficial) choco:// Protocol support](https://community.chocolatey.org/packages/choco-protocol-support)

---

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

## Package Parameters

* `/NoShim` - Opt out of creating a GUI shim.
* `/NoDesktopShortcut` - Opt out of creating a Desktop shortcut.
* `/NoProgramsShortcut` - Opt out of creating a Programs shortcut in your Start Menu.
* `/Start` - Automatically start OpenRGB after installation completes.

## Package Notes

This package may create a [shim](https://docs.chocolatey.org/en-us/features/shim) for `OpenRGB.exe`, as is typical for a portable application package. However, `shimgen` will create a GUI shim, which will not wait for the underlying process to exit by default. This may cause issues with displaying console output when using the command-line interface. Users requiring this functionality should pass the `--shimgen-waitforexit` switch to ensure the shim behaves correctly.

---

When using the `/Start` package parameter, you may see a large `CLIXML` block logged to `stderr`. This is [a known issue](https://github.com/chocolatey/choco/issues/1016) with Chocolatey's `Start-ChocolateyProcessAsAdmin` cmdlet, and is not necessarily indicative of an error condition. Until this is addressed, you should ensure the `failOnStandardError` feature is disabled while installing/upgrading this package.

---

For future upgrade operations, consider opting into Chocolatey's `useRememberedArgumentsForUpgrades` feature to avoid having to pass the same arguments with each upgrade:

```shell
choco feature enable --name="'useRememberedArgumentsForUpgrades'"
```
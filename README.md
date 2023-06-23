![ANSI Logo](https://gitlab.com/kyaulabs/aarch/raw/master/aarch.ans.png "ANSI Logo")  
<a href="https://kyaulabs.com/">https://kyaulabs.com/</a>

[![Contributor Covenant](https://img.shields.io/badge/contributor%20covenant-2.1-4baaaa.svg)](CODE_OF_CONDUCT.md) &nbsp; [![Semantic Versioning](https://img.shields.io/badge/semantic%20versioning-2.6.6-333333.svg)](https://semver.org) &nbsp; [![GitHub](https://img.shields.io/github/license/kyaulabs/aarch)](LICENSE) &nbsp; [![Gitleaks](https://img.shields.io/badge/protected%20by-gitleaks-blue)](https://github.com/zricethezav/gitleaks) &nbsp; [![CI](https://img.shields.io/github/actions/workflow/status/kyaulabs/aarch/shellcheck.yml)](../../actions)  

## Disclaimer

I personally use Arch Linux everywhere and with the frequency at which I was doing reinstallations increasing, eventually I needed a better solution. What started as a hardening script that was run post-installation has merged into the fully automated installation script that you see before you.

```
🚧 WARNING
This repository is provided for archival/educational purposes, I am not responsible for any data loss or
damage that may ensue.
```

* [Introduction](#introduction)
* [Configuration](#configuration)
  * [Custom ARCHISO](#custom-archiso)
  * [Existing ARCHISO](#existing-archiso)
* [Usage](#usage)
* [Attribution](#attribution)

## Introduction
AArch or Automated Arch Linux is a template-based automated installer for Arch
Linux. This script is the convergence of my
[Arch Linux Installation](https://kyau.net/wiki/ArchLinux:Installation) along
with my
[Hardening Arch Linux (HAL)](https://kyau.net/wiki/ArchLinux:Security) articles
on my personal wiki.

## Configuration

Before you can start `aarch`, a `moduli` must be generated. This will take a
considerable amount of time depending on your CPU, if this is being executed
inside of a virtualized environment it is recommended that you use `haveged`.

```bash
ssh-keygen -M generate -O bits=4096 moduli.c
ssh-keygen -M screen -f moduli.c moduli
rm moduli.c
```

After the `moduli` has been generated the `example.aa` file can be edited for
a fully automated installation. This file can be named anything you like as long
as it retains it's extension (eg. machine.aa). Without a template file you will
instead be asked to input all of the information to the console when running
`aarch`.

Boot up the machine and/or vm with an ARCHISO image.



### Custom ARCHISO

Next decide if you want the script baked into an ISO or if you just want to
`scp` the script to the installation environment everytime. If you choose to
build your own ARCHISO it will help to follow these guidelines:

* Use `releng` as your base template.
* Add the `git` and `wget` packages to the `packages.x86_64` file so that it
will be installed an usable in the installation environment.
* Revert to traditional interface names with `ln -s /dev/null airootfs/etc/udev/rules.d/80-net-setup-link.rules`
* `aarch`, `erase_hdd`, `firstboot.txt` and `moduli` must be placed into in the `airootfs/root`
directory prior to building.
* Include an `.aa` template file in the `airootfs/root` directory for script
automation.
* Also include an wanted packages from the `pkg` directory.
* Modify the `profiledef.sh` script to make sure `aarch`, `erase_hdd` and any
packages you included have `0:0:755` setting, this sets user:group:permissions.
* Modify the `airootfs/root/.zlogin` script to enable the `sshd.service` on boot
by adding `systemctl enable --now sshd.service`. Then set a root password with
the command `chpasswd <<< "root:moo"`, with 'moo' being the password.

Instructions for building your own image can be found
[here](https://wiki.archlinux.org/index.php/Archiso).

### Existing ARCHISO

If instead you choose not to bake the script into an ISO, simply boot an
existing ARCHISO, use the `E` key to edit the kernel commandline at the bootloader
menu, adding `net.ifnames=0` to boot with traditional network interface names.

The ARCHISO will automatically log you into the root account, install `git` and
`wget`.

```shell
pacman -Syy git wget
```

Then modify the root password and enable sshd, finally checking the assigned IP.

```shell
passwd
systemctl start sshd
ip a
```

Finally SCP over to the machine `aarch`, `erase_hdd`, `firstboot.txt`, `moduli`
and an `.aa` template.

## Usage

In order to run `aarch` properly you will need all of the following files in
the home directory of the root user in the livecd environment for the machine
or virtual machine you are trying to install.

```shell
aarch erase_hdd firstboot.txt moduli
```

*In addition it also pays to have an `.aa` template.*

To run, simply execute the script.

```shell
./aarch
```

This will read the first `.aa` template found in the current directory. If no
template is found it will prompt the user to input the configuration through
the console.

*Absolute automation can be achieved by adding `aarch` to the `.bashrc` of the
root user on the ISO in addition to including a pre-filled in `.aa` template.*

## Attribution

* [ArchWiki](https://wiki.archlinux.org/)
* [Arch Linux Installation](https://kyau.net/wiki/ArchLinux:Installation)
* [Hardening Arch Linux (HAL)](https://kyau.net/wiki/ArchLinux:Security)
* [Mozilla SSL Configuration Generator](https://ssl-config.mozilla.org/)

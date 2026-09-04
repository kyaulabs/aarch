![ANSI Logo](https://gitlab.com/kyaulabs/aarch/raw/master/aarch.ans.png "ANSI Logo")

[![Contributor Covenant](https://img.shields.io/badge/contributor%20covenant-2.1-4baaaa.svg?logo=open-source-initiative&logoColor=4baaaa)](CODE_OF_CONDUCT.md)
[![Conventional Commits](https://img.shields.io/badge/conventional%20commits-1.0.0-fe5196?style=flat&logo=conventionalcommits)](https://conventionalcommits.org)
[![GitHub](https://img.shields.io/github/license/kyaulabs/template?logo=creativecommons)](LICENSE)
[![Semantic Versioning](https://img.shields.io/badge/release-2.6.7-red?logo=semver)](https://semver.org)
[![CI](https://img.shields.io/github/actions/workflow/status/kyaulabs/aarch/shellcheck.yml)](../../actions)
[![Gitleaks](https://img.shields.io/badge/protected%20by-gitleaks-blue?logo=git&logoColor=seagreen&color=seagreen)](https://github.com/zricethezav/gitleaks)

## About

I personally use Arch Linux everywhere and eventually wanted the ability to spin up new instances at will. What started as a hardening script that was run post-installation has merged into the fully automated installation script that you see before you.

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

Before you can start `aarch.sh`, a `moduli` must be generated. This will take a
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
`aarch.sh`.

Boot up the machine and/or vm with an ARCHISO image.

### Custom ARCHISO

Next decide if you want the script baked into an ISO or if you just want to
`scp` the script to the installation environment everytime. If you choose to
build your own ARCHISO it will help to follow these guidelines:

* Use `releng` as your base template.
* Add the `git` and `wget` packages to the `packages.x86_64` file so that it
will be installed and usable in the installation environment.
* Revert to traditional interface names with `ln -s /dev/null airootfs/etc/udev/rules.d/80-net-setup-link.rules`
* `aarch.sh`, `erase_hdd.sh`, `firstboot.sh`, `moduli`, and `wifi.sh` must be
placed in the `airootfs/root` directory prior to building.
* Include an `.aa` template file in the `airootfs/root` directory for script
automation.
* Also include an wanted packages from the `pkg` directory.
* Modify the `profiledef.sh` script to make sure `aarch.sh`, `erase_hdd.sh`,
`wifi.sh` and any packages you included have a `0:0:755` setting; this sets
user:group:permissions.
* Modify the `airootfs/root/.zlogin` script to enable the `sshd.service` on boot
by adding `systemctl enable --now sshd.service`. Then set a root password with
the command `chpasswd <<< "root:moo"`, with 'moo' being the password.

Instructions for building your own image can be found on the
[ArchWiki](https://wiki.archlinux.org/index.php/Archiso).

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

Finally, SCP `aarch.sh`, `erase_hdd.sh`, `firstboot.sh`, `moduli`, and an `.aa`
template to the machine.

## Usage

In order to run `aarch.sh` properly you will need all of the following files in
the home directory of the root user in the live CD environment for the machine
or virtual machine you are trying to install.

```text
aarch.sh erase_hdd.sh firstboot.sh moduli
```

*In addition it also pays to have an `.aa` template.*

To run, simply execute the script.

```shell
./aarch.sh
```

This will read the first `.aa` template found in the current directory. If no
template is found it will prompt the user to input the configuration through
the console.

*Absolute automation can be achieved by adding `aarch.sh` to the `.bashrc` of
the root user on the ISO in addition to including a pre-filled `.aa` template.*

## Attribution

* [ArchWiki](https://wiki.archlinux.org/)
* [Arch Linux Installation](https://kyau.net/wiki/ArchLinux:Installation)
* [Hardening Arch Linux (HAL)](https://kyau.net/wiki/ArchLinux:Security)
* [Mozilla SSL Configuration Generator](https://ssl-config.mozilla.org/)

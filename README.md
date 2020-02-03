![ANSI Logo](https://gitlab.com/kyaulabs/aarch/raw/master/aarch.ans.png "ANSI Logo")  
<a href="https://kyaulabs.com/">https://kyaulabs.com/</a>

[![](https://img.shields.io/badge/coded_in-vim-green.svg?logo=vim&logoColor=brightgreen&colorB=brightgreen&longCache=true&style=flat)](https://vim.org) &nbsp; [![](https://img.shields.io/badge/license-AGPL_v3-blue.svg?style=flat)](https://gitlab.com/kyaulabs/aarch/blob/master/LICENSE) &nbsp; [![](https://img.shields.io/badge/build-passing-success?style=flat)](https://www.shellcheck.net/)
[![](https://img.shields.io/badge/bash-5.0.x-8E68AC.svg?style=flat)](https://www.gnu.org/software/bash/)

### About
AArch or Automated Arch Linux is a template-based automated installer for Arch
Linux. This script is the convergence of my
[Arch Linux Installation](https://kyau.net/wiki/ArchLinux:Installation) along
with my
[Hardening Arch Linux (HAL)](https://kyau.net/wiki/ArchLinux:Security) articles
on my personal wiki.

### Preparations
Before you can use aarch, a `moduli` must be generated. This will take a
considerable amount of time depending on your CPU, if this is being executed
in a virtualized environment it is recommended that you use `haveged`.

```shell
ssh-keygen -G mtmp -b 2048 && ssh-keygen -T moduli -f mtmp && rm mtmp
```

After the `moduli` has been generated the `example.aa` file can be edited for
a fully automated installation. This file can be named anything you like as long
as it retains it's extension (eg. machine.aa). Without a template file you will
instead be asked to input all of the information to the console when running
`aarch`.

### ARCHISO

Next decide if you want the script baked into an ISO or if you just want to
`scp` the script to the installation environment everytime. If you choose to
build your own ARCHISO it will help to follow these guidelines:

* Use `releng` as your base template.
* Add the `git` package to the `packages.x86_64` file so that it will be
installed an usable in the installation environment.
* `aarch`, `firstboot.txt` and `moduli` must be placed into in the `airootfs/root`
directory prior to building and must be owned by root.
* Include an `.aa` template file in the `airootfs/root` directory for script
automation.
* Modify the `airootfs/root/customize_airootfs.sh` script to enable the
`sshd.service` on boot by adding it to the 'systemctl enable' line. Then set a
root password with the command `chpasswd <<< "root:moo"`, with 'moo' being the
password you set it to.

Instructions for building your own image can be found
[here](https://wiki.archlinux.org/index.php/Archiso).

If instead you choose not to bake the script into an ISO, simply boot an
existing ARCHISO and use `pacman` to install git. Then modify the root password
and enable sshd. Finally SCP over to the machine `aarch`, `firstboot.txt`,
`moduli` and an `.aa` template.

### Usage

To run, simply execute the `aarch` script, this will read the first `.aa`
template found in the current directory and if not found it will prompt the user
for input.

Absolute automation can be achieved by adding `aarch` to the `.bashrc` of the
root user on the ISO in addition to including a pre-filled in `.aa` template.

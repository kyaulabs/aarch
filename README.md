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

### Usage
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

Next decide if you want the script baked into an ISO or if you just want to
`scp` the script to the installation environment everytime. If you choose to
build your own ARCHISO it will help to follow these guidelines:

* Use `releng` as your base template.
* Add the `git` package to the `packages.x86_64` file so that it will be
installed an usable in the installation environment.
* `aarch`, `example.aa` and `moduli` must be placed into in the `airootfs/root`
directory prior to building and must be owned by root.
* Modify the `airootfs/root/customize_airootfs.sh` script to enable the
`sshd.service` on boot by adding it to the 'systemctl enable' line. Then set a
root password with the command `chpasswd <<< "root:moo"`, with 'moo' being the
password you set it to.

Instructions for building your own image can be found
[here](https://wiki.archlinux.org/index.php/Archiso).

Once booted simply execute the `aarch` script (after you have successfully used
`scp` to copy it over if you did not bake it into the ISO).

Absolute automation can be achieved by adding `aarch` to the `.bashrc` of the
root user on the ISO.

# Ben's installation guide

## Get arch

### Download it

[here](https://archlinux.org/download/)

Verify file signature:
> $ gpg --keyserver-options auto-key-retrieve --verify archlinux-version-x86_64.iso.sig
or from an existing arch install
> $ pacman-key -v archlinux-version-x86_64.iso.sig

### Create media

dd it to pendrive:
> $ dd bs=4M if=path/to/archlinux.iso of=/dev/sdx status=progress oflag=sync

## Installation

### Boot it up !

Load the keyboard layout
> $ loadkeys be-latin1

Connect to the internet using wifi-menu
> $ wifi-menu

Update system-clock
> $ timedatectl set-ntp true

### Prepare the disk

Wipe the disk using dm-crypt
> $ cryptsetup open --type plain -d /dev/urandom /dev/sdX to_be_wiped
> $ dd bs=1M if=/dev/zero of=/dev/mapper/to_be_wiped status=progress
> $ cryptsetup close to_be_wiped

### Partition (LUKS on LVM)

**We chose GPT so we use gdisk.**

To be able to span both drive with the LUKS encryption we need to use LUKS on LVM.

+----------------+-------------------------------------------------------------------------------------------------+
| Boot partition | dm-crypt plain encrypted volume | LUKS2 encrypted volume        | LUKS2 encrypted volume        |
|                |                                 |                               |                               |
| /boot          | [SWAP]                          | /                             | /home                         |
|                |                                 |                               |                               |
|                | /dev/mapper/swap                | /dev/mapper/root              | /dev/mapper/home              |
|                |_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _|_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _|_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _|
|                | Logical volume 1                | Logical volume 2              | Logical volume 3              |
|                | /dev/MyVolGroup/cryptswap       | /dev/MyVolGroup/cryptroot     | /dev/MyVolGroup/crypthome     |
|                |_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _|_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _|_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _|
|   EFI ef00     |                                   Linux LVM 8e00                                                |
|   512.0MiB     |                                   118.7GiB                                                      |
|   /dev/sda1    |                                   /dev/sda2                                                     |
+----------------+-------------------------------------------------------------------------------------------------+





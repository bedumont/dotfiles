# Ben's installation guide

> The following has been sourced almost entirely from the Arch wiki. Thanks to all the contributors for this amazing resource.

## Get arch

### Download it [here](https://archlinux.org/download/)

Verify file signature:

    # gpg --keyserver-options auto-key-retrieve --verify archlinux-version-x86_64.iso.sig

or from an existing arch install

    # pacman-key -v archlinux-version-x86_64.iso.sig

### Create media

dd it to pendrive:

    # dd bs=4M if=path/to/archlinux.iso of=/dev/sdx status=progress oflag=sync

## Installation

### Boot it up !

Load the keyboard layout

    # loadkeys be-latin1

Connect to the internet using wifi-menu

    # wifi-menu

Update system-clock

    # timedatectl set-ntp true

### Prepare the disk

Wipe the disk using dm-crypt

    # cryptsetup open --type plain -d /dev/urandom /dev/sdX to_be_wiped
    # dd bs=1M if=/dev/zero of=/dev/mapper/to_be_wiped status=progress
    # cryptsetup close to_be_wiped

### Partition (LUKS on LVM)

**We chose GPT so we use gdisk**

To be able to span both drives with the LUKS encryption we need to use LUKS on LVM

    +----------------+-----------------------------------------------------------------------------------+
    | Boot partition | LUKS2 encrypted    | dm-crypt plain     | dm-crypt plain     | LUKS2 encrypted    |
    |                |  volume            |  encrypted volume  |  encrypted volume  |  volume            |
    |                |                    |                    |                    |                    |
    | /boot          | /                  | [SWAP]             | /tmp               | /home              |
    |                |                    |                    |                    |                    |
    |                | /dev/mapper/root   | /dev/mapper/swap   | /dev/mapper/tmp    | /dev/mapper/home   |
    |                |_ _ _ _ _ _ _ _ _ _ |_ _ _ _ _ _ _ _ _ __|_ _ _ _ _ _ _ _ _ _ |_ _ _ _ _ _ _ _ _ __|
    |                | Logical volume 1   | Logical volume 2   | Logical volume 3   | Logical volume 4   |
    |                | /dev/mvg/cryptroot | /dev/mvg/cryptswap | /dev/mvg/crypttmp  | /dev/mvg/crypthome |
    |                |_ _ _ _ _ _ _ _ _ _ |_ _ _ _ _ _ _ _ _ __|_ _ _ _ _ _ _ _ _ _ |_ _ _ _ _ _ _ _ _ __|
    |   EFI ef00     |                                     Linux LVM 8e00                                |
    |   512.0MiB     |                                     118.7GiB                                      |
    |   /dev/sda1    |                                     /dev/sda2                                     |
    +----------------+-----------------------------------------------------------------------------------+

    +----------------------------------------------------------------------------------------------------+
    |                                       LUKS2 encrypted volume                                       |
    |                                                                                                    |
    |                                                                                                    |
    |                                       /home                                                        |
    |                                                                                                    |
    |                                       /dev/mapper/home                                             |
    |__ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _|
    |                                       Logical volume 4                                             |
    |                                       /dev/mvg/crypthome                                           |
    |__ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _|
    |                                       Linux LVM 8e00                                               |
    |                                       465.6GiB                                                     |
    |                                       /dev/sdb1                                                    |
    +----------------------------------------------------------------------------------------------------+

Create physical and logical volumes

    # pvcreate /dev/sda2
    # vgcreate mvg /dev/sda2
    # lvcreate -L 64G -n cryptroot mvg
    # lvcreate -L 4G -n cryptswap mvg
    # lvcreate -L 500M -n crypttmp mvg
    # lvcreate -l 100%FREE -n crypthome mvg

Encrypt cryptroot (default options), create FS (ext4) and mount it at /mnt

    # cryptsetup luksFormat /dev/mvg/cryptroot
    # cryptsetup open /dev/mvg/cryptroot root
    # mkfs.ext4 /dev/mapper/root
    # mount /dev/mapper/root /mnt

Create FS for boot partition

    # dd if=/dev/zero of=/dev/sda1 bs=1M status=progress
    # mkfs.fat -F32 /dev/sda1
    # mkdir /mnt/boot
    # mount /dev/sda1 /mnt/boot

### Pacstrap and chroot

Edit mirrors

    # vim /etc/pacman.d/mirrorlist

Install arch

    # pacstrap /mnt base linux linux-firmware

Generate fstab

    # genfstab -U /mnt >    /mnt/etc/fstab

Chroot into the new system

    # arch-chroot /mnt

Install vim obviously

    # pacman -S vim

### Set time and locales

Set the time-zone

    # ln -sf /usr/share/zoneinfo/Europe/Brussels /etc/localtime

And run

    # hwclock --systohc

Uncomment locales and generate them

    # vim /etc/locale.gen
    ---------------------
    en_US.UTF-8 UTF-8  
    en_US ISO-8859-1  
    fr_BE.UTF-8 UTF-8  
    fr_BE ISO-8859-1  
    fr_BE@euro ISO-8859-15  

    # locale-gen

Create the locale.conf file and set de LANG variable

    # vim /locale.conf
    ------------------
    LANG=en_US.UTF-8

Make keyboard layout persistent

    # vim /etc/vconsole.conf
    ------------------------
    KEYMAP=be-latin1

### Configure network

Create hostname file

    # vim /etc/hostname
    -------------------
    archX230

Match entries to hosts and ban 9gag

    # vim /etc/hosts
    ----------------
    127.0.0.1	localhost
    ::1 		localhost
    127.0.0.1	archX230.localdomain archX230
    
    0.0.0.0     9gag.com

Install iwd
    
    # pacman -S iwd

Create and edit iwd config file

    # sudo vim /etc/iwd/main.conf
    -----------------------------
    [General]
    use_default_interface=true

    [Network]
    NameResolvingService=systemd

Then enable iwd, systemd-networkd and systemd-resolved services

    # systemctl enable iwd.service && systemctl enable systemd-networkd.service systemctl enable systemd-resolved.service

### Initramfs

Edit mkinitcpio config file with the following kernel hooks (assuming encrypt hook, not sd-encrypt):

    # vim /etc/mkinitcpio.conf
    --------------------------
    HOOKS=(base udev autodetect keyboard keymap modconf block lvm2 encrypt filesystems fsck)

Recreate the initramfs image

    # mkinitcpio -P

### Root password

Set root password

    # passwd

### Bootloader

Install systemd-boot

    # bootctl --path=/boot install

Install intel microcode

    # pacman -S 

Find the drives UUID

    # blkid -s UUID -o value /dev/mapper/root >> /boot/load/entries/arch-encrypted.conf

Create config file. **BEWARE, the UUID must be the UUID of the LUKS encrypted partition, not the unencrypted root partition**

The acpi_osi= option is set to enable brightness control using the fn keys

    # vim /boot/loader/entries/arch-encrypted.conf
    ------------------------------------------
    title   Arch Linux Encrypted
    linux   /vmlinuz-linux
    initrd  /initramfs-linux.img
    options cryptdevice=UUID=<UUID>:root root=/dev/mapper/root rw acpi_osi=

### Configuring crypttab and fstab

To automatically re-encrypt temporary filesystems (swap and tmp) at reboot

    # vim /etc/crypttab
    --------------
    swap    /dev/mvg/cryptswap   /dev/urandom    swap,cipher=aes-xts-plain64,size=256
    tmp     /dev/mvg/crypttmp    /dev/urandom    tmp,cipher=aes-xts-plain64,size=256

    # vim /etc/fstab
    ----------------
    /dev/mapper/tmp     /tmp        tmpfs       defaults        0       0
    /dev/mapper/swap    none        swap        default,pri=-2  0       0
    
**REBOOT**

### Encrypt the home partition

    Create a key for decrypting the partition

    # mkdir -m 700 /etc/luks-keys
    # dd if=/dev/random of=/etc/luks-keys/home bs=1 count=256 status=progress
    
    Encrypt the partition with the key

    # cryptsetup luksFormat -v /dev/mvg/crypthome /etc/luks-keys/home
    # cryptsetup -d /etc/luks-keys/home open /dev/mvg/crypthome home
    # mkfs.ext4 /dev/mapper/home
    # mount /dev/mapper/home /home

Edit crypttab and fstab to enable decryption of home partition

    # vim /etc/crypttab
    -------------------
    home    /dev/MyVolGroup/crypthome   /etc/luks-keys/home
    
    # vim /etc/fstab
    ----------------
    /dev/mapper/home        /home   ext4        defaults        0       2

### Users configuration

Create yourself

    # useradd -m -G wheel ben
    # passwd ben

Install sudo and uncomment wheel group

    # pacman -S sudo

    # EDITOR=vim visudo
    -------------------
    %wheel ALL=(ALL) ALL

## Global config

### Dotfiles

Clone the dotfile repoo

### Keyboard in X

Config keymap for Xorg

    # localectl --no-convert set-x11-keymap be


## Expanding lvm on multiple disks

### Add a new drive

Connect using root or from a live USB, create a signle Linux LVM partitoon on the drive (8e00) using gdisk and create the physical volume:

    # pvcreate /dev/sdY1
    # vgextend mvg /dev/sdY1

### Extend the logical volume

Expand the mvg/crypthome with fresh disk space

    # umount /home
    # fsck /dev/mapper/home
    # cryptsetup luksClose /dev/mapper/home
    # lvextend -l +100%FREE mvg/crypthome

The logical volume is then extended

    # cryptsetup open /dev/mvg/crypthome home
    # umount /home
    # cryptsetup --verbose resize home

Finally the file system is resized

    # e2fsck -f /dev/mapper/home
    # resize2fs /dev/mapper/home

The /home can be remounted

    # mount /dev/mapper/home /home

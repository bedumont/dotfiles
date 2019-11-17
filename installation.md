# Ben's installation guide

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

To be able to span both drive with the LUKS encryption we need to use LUKS on LVM

    +----------------+-----------------------------------------------------------------------------------+
    | Boot partition | dm-crypt plain encrypted  | LUKS2 encrypted volume    | LUKS2 encrypted volume    |
    |                | volume                    |                           |                           |
    |                |                           |                           |                           |
    | /boot          | [SWAP]                    | /                         | /home                     |
    |                |                           |                           |                           |
    |                | /dev/mapper/swap          | /dev/mapper/root          | /dev/mapper/home          |
    |                |_ _ _ _ _ _ _ _ _ _ _ _ _ _|_ _ _ _ _ _ _ _ _ _ _ _ _ _|_ _ _ _ _ _ _ _ _ _ _ _ _ _|
    |                | Logical volume 1          | Logical volume 2          | Logical volume 3          |
    |                | /dev/MyVolGroup/cryptswap | /dev/MyVolGroup/cryptroot | /dev/MyVolGroup/crypthome |
    |                |_ _ _ _ _ _ _ _ _ _ _ _ _ _|_ _ _ _ _ _ _ _ _ _ _ _ _ _|_ _ _ _ _ _ _ _ _ _ _ _ _ _|
    |   EFI ef00     |                             Linux LVM 8e00                                        |
    |   512.0MiB     |                             118.7GiB                                              |
    |   /dev/sda1    |                             /dev/sda2                                             |
    +----------------+-----------------------------------------------------------------------------------+

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

Install connman and iwd
    
    # pacman -S connman iwd

Create the two services for connman to use iwd:

    # vim /etc/systemd/system/iwd.service
    -------------------------------------
    [Unit]
    Description=Internet Wireless Daemon (IWD)
    Before=network.target
    Wants=network.target
    
    [Service]
    ExecStart=/usr/lib/iwd/iwd
    
    [Install]
    Alias=multi-user.target.wants/iwd.service

    # vim /etc/systemd.system/connman_iwd.service
    ---------------------------------------------
    [Unit]
    Description=Connection service
    DefaultDependencies=false
    Conflicts=shutdown.target
    RequiresMountsFor=/var/lib/connman
    After=dbus.service network-pre.target systemd-sysusers.service iwd.service
    Before=network.target multi-user.target shutdown.target
    Wants=network.target
    Requires=iwd.service
    
    [Service]
    Type=dbus
    BusName=net.connman
    Restart=on-failure
    ExecStart=/usr/bin/connmand --wifi=iwd_agent -n 
    StandardOutput=null
    CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_NET_RAW CAP_SYS_TIME CAP_SYS_MODULE
    ProtectHome=true
    ProtectSystem=true
    
    [Install]
    WantedBy=multi-user.target 
Then enable the services

    # systemctl enable connman.service connman_iwd.service

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

    # vim /boot/loader/entries/arch-encrypted.conf
    ------------------------------------------
    title   Arch Linux Encrypted
    linux   /vmlinuz-linux
    initrd  /initramfs-linux.img
    options cryptdevice=UUID=<UUID>:root resume=/dev/mapper/swap root=/dev/mapper/root rw

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

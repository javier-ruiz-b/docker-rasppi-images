#!/bin/bash
set -euxo pipefail
qemu-img resize *raspios*.img -f raw +2G
parted *raspios*.img resizepart 2 100%

losetup -D

root_part_start=$(fdisk -l *raspios*.img | grep '\.img2' | awk '{print $2}')
root_dev=$(losetup -f --offset $((root_part_start*512)) --show *raspios*.img)
e2fsck -f $root_dev
resize2fs $root_dev

losetup -D

boot_part_start=$(fdisk -l *raspios*.img | grep '\.img1' | awk '{print $2}')
boot_part_size=$(fdisk -l *raspios*.img | grep '\.img1' | awk '{print $4}')

mkdir /mnt/root
mount -o loop,offset=$((root_part_start*512)) *raspios*.img /mnt/root
mkdir -p /mnt/root/boot
mount -o loop,offset=$((boot_part_start*512)),sizelimit=$((boot_part_size*512)) *raspios*.img /mnt/root/boot
# ls /mnt/*/

cd /mnt/root/
mount -t proc /proc proc/
mount --rbind /sys sys/
mount --rbind /dev dev/

/etc/init.d/binfmt-support start

cp -r /rootcopy/* /mnt/root/
chroot /mnt/root/ bash /var/tmp/setup.sh || chroot /mnt/root/ bash

umount /mnt/root/boot
umount -l /mnt/root || true
sync

# bash

cp /*raspios*.img /src
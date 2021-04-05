#!/bin/bash
set -euxo pipefail

bash /decompress-image.sh

qemu-img resize *raspios*.img -f raw +2G
parted *raspios*.img resizepart 2 100%

losetup -D

root_part_start=$(fdisk -l *raspios*.img | grep '\.img2' | awk '{print $2}')
root_dev=$(losetup -f --offset $((root_part_start*512)) --show *raspios*.img)
e2fsck -f $root_dev
resize2fs $root_dev

losetup -D

bash /mount.sh

cp -r /rootcopy/* /mnt/root/
cd /mnt/root/
tar xfz /src/cross-compile-output/contents.tgz || ( echo "Run cross compile before."; exit 1)

chroot /mnt/root/ bash /var/tmp/setup.sh || chroot /mnt/root/ bash

umount /mnt/root/boot
umount -l /mnt/root || true
sync

# bash

cp /*raspios*.img /src
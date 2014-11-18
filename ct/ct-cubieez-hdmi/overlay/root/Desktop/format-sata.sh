#!/bin/sh
umount /dev/sd* 
dd if=/dev/zero of=/dev/sda bs=1M count=1
        sync
        sata=/dev/sda
        touch /root/resizefs
        echo "
n
p
1



w
q
        " | fdisk ${sata} > /dev/null
        mkfs.ext4 /dev/sda1


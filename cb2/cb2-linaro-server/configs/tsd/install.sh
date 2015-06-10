#!/bin/bash
card="mmcblk0"

flash_start()
{
        echo -e  "******************start to flash************" > /dev/tty1
	return 0
}

flash_when_err()
{
	echo -e  "############################################" > /dev/tty1
        echo -e "\033[40;32;1m       failed  to flash        \e[0m" > /dev/tty1
        echo -e "\033[40;32;1m       failed  to flash        \e[0m" > /dev/tty1
        echo -e "\033[40;32;1m       failed  to flash        \e[0m" > /dev/tty1
	echo -e  "############################################" > /dev/tty1

	exit 0
}

flash_end()
{
	return 0
}

part_card()
{

#    sfdisk -R /dev/$card
#    sfdisk --force --in-order -uS /dev/$card <<EOF
#2048,24576,L
#,,L
#EOF
flag=`fdisk -l /dev/mmcblk0 | grep Units | grep 8192`
if [ -n "$flag" ] ; then
echo 8192
fdisk /dev/$card <<EOF
o
n
p
1
128
2048
n
p
2
2049

w
EOF

else
echo 32768
fdisk /dev/$card <<EOF
o
n
p
1
32
544
n
p
2
545

w
EOF
fi
	if [ $? -ne 0 ]; then
		echo "err in sfdisk" > /log.txt
		flash_when_err
	fi

    sync
	echo y |  mkfs.ext2 /dev/${card}p1
	if [ $? -ne 0 ]; then
		echo "err in mkfs p1" > /log.txt
		flash_when_err
	fi
	echo y |  mkfs.ext4 /dev/${card}p2
	if [ $? -ne 0 ]; then	
		echo "err in mkfs p2" > /log.txt
		flash_when_err
	fi
	return 0
}

install_card()
{
	mkdir -p /mnt/p1 /mnt/p2
	if [ $? -ne 0 ]; then
		echo "err in mkdir p1 p2" > /log.txt
		flash_when_err
	fi

	mount /dev/${card}p1	/mnt/p1
	if [ $? -ne 0 ]; then
		echo "err in mount p1" > /log.txt
		flash_when_err
	fi

	mount /dev/${card}p2	/mnt/p2
	if [ $? -ne 0 ]; then
		echo "err in mount p2" > /log.txt
		flash_when_err
	fi

	tar -C /mnt/p2 -zxmpf /rootfs.tar.gz
	if [ $? -ne 0 ]; then
		echo "err in tar rootfs" > /log.txt
		flash_when_err
	fi

	sync
	cp /bootfs/*	/mnt/p1
	if [ $? -ne 0 ]; then
		echo "err in cp bootfs" > /log.txt
		flash_when_err
	fi

	dd if=/bootfs/u-boot.bin of=/dev/$card bs=1024 seek=8
	if [ $? -ne 0 ]; then
		echo "err in dd u-boot" > /log.txt
		flash_when_err
	fi
	sync
	umount /mnt/*
	rm -fr /mnt/p1 /mnt/p2
	return 0
}

shutdown()
{
	poweroff
	return 0
}


flash_start
part_card
install_card
flash_end
shutdown


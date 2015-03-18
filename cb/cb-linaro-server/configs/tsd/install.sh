#!/bin/bash
card="mmcblk0"
LED1_TRIGGER="/sys/class/leds/led1/trigger"
LED1_BRIGHT="/sys/class/leds/led1/brightness"

led_start()
{
	echo "timer" > ${LED1_TRIGGER}
	return 0
}

led_when_err()
{
	echo "none" > ${LED1_TRIGGER}
	echo 1 > ${LED1_BRIGHT}
	exit 0
}

part_card()
{

#    sfdisk -R /dev/$card
#    sfdisk --force --in-order -uS /dev/$card <<EOF
#2048,24576,L
#,,L
#EOF

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


	if [ $? -ne 0 ]; then
		echo "err in sfdisk" > /log.txt
		led_when_err
	fi

    sync
	echo y |  mkfs.ext2 /dev/${card}p1
	if [ $? -ne 0 ]; then
		echo "err in mkfs p1" > /log.txt
		led_when_err
	fi
	echo y |  mkfs.ext4 /dev/${card}p2
	if [ $? -ne 0 ]; then	
		echo "err in mkfs p2" > /log.txt
		led_when_err
	fi
	return 0
}

install_card()
{
	mkdir -p /mnt/p1 /mnt/p2
	if [ $? -ne 0 ]; then
		echo "err in mkdir p1 p2" > /log.txt
		led_when_err
	fi

	mount /dev/${card}p1	/mnt/p1
	if [ $? -ne 0 ]; then
		echo "err in mount p1" > /log.txt
		led_when_err
	fi

	mount /dev/${card}p2	/mnt/p2
	if [ $? -ne 0 ]; then
		echo "err in mount p2" > /log.txt
		led_when_err
	fi

	tar -C /mnt/p2 -zxmpf /rootfs.tar.gz
	if [ $? -ne 0 ]; then
		echo "err in tar rootfs" > /log.txt
		led_when_err
	fi

	sync
	cp /bootfs/*	/mnt/p1
	if [ $? -ne 0 ]; then
		echo "err in cp bootfs" > /log.txt
		led_when_err
	fi

	dd if=/bootfs/u-boot.bin of=/dev/$card bs=1024 seek=8
	if [ $? -ne 0 ]; then
		echo "err in dd u-boot" > /log.txt
		led_when_err
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


led_start
part_card
install_card
shutdown


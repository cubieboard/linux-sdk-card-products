#!/bin/bash

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

led_over()
{
	echo "none" > ${LED1_TRIGGER}
	echo 0 > ${LED1_BRIGHT}
	return 0
}

part_nand()
{
dd if=/sys_partition of=/dev/nand bs=1M
echo y  | nand-part -f a20 /dev/nand 32768 \
                                'bootloader 294912' \
                                'rootfs 0' \

	if [ $? -ne 0 ]; then
		echo "err in sfdisk" > /log.txt
		led_when_err
	fi

    sync
	dd if=/bootloader.fex of=/dev/nanda bs=1M
	sync

	echo y |  mkfs.ext4 /dev/nandb
	if [ $? -ne 0 ]; then
		echo "err in mkfs p2" > /log.txt
		led_when_err
	fi
	return 0
}

install_nand()
{
	mkdir -p /mnt/p1 /mnt/p2
	if [ $? -ne 0 ]; then
		echo "err in mkdir p1 p2" > /log.txt
		led_when_err
	fi

	mount /dev/nanda	/mnt/p1
	if [ $? -ne 0 ]; then
		echo "err in mount p1" > /log.txt
		led_when_err
	fi

	mount /dev/nandb	/mnt/p2
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
	cp -fr /bootfs/uImage	/mnt/p1
	cp -fr /bootfs/uEnv.txt	/mnt/p1
	if [ $? -ne 0 ]; then
		echo "err in cp bootfs" > /log.txt
		led_when_err
	fi

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
part_nand
install_nand
led_over
shutdown


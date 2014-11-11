#!/bin/bash

export CB_PRODUCT_ROOTFS_IMAGE=${CB_PACKAGES_DIR}/cubieez-ct-20140916.tar.gz
export CB_PRODUCT_ROOTFS_EXT4=${CB_PACKAGES_DIR}/cubieez-ct-20140916.ext4
export CB_OUTPUT_ROOTFS_EXT4=${CB_OUTPUT_DIR}/cubieez-ct-20140916.ext4
export CB_ROOTFS_SIZE=1500
export CB_BOOTFS_SIZE=61
export CB_PRODUCT_ONLY_KERNEL=0
export U_BOOT_NAND=${CB_PACKAGES_DIR}/u-boot-a20/u-boot-nand.bin
export U_BOOT_WITH_SPL=${CB_PACKAGES_DIR}/u-boot-a20/u-boot-sunxi-with-spl-ct-20131102.bin
export U_BOOT_WITH_SPL_MMC2=${CB_PACKAGES_DIR}/u-boot-a20/u-boot-sunxi-with-spl-ct-20140806-mmc2.bin
export U_BOOT_NAND=${CB_PACKAGES_DIR}/u-boot-a20/u-boot-nand.bin
export CB_FLASH_TSD_ROOTFS_SIZE=25

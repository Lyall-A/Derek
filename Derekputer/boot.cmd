# Set kernel boot args
setenv bootargs console=ttyS0,115200 root=/dev/mmcblk0p1 rootwait rw panic=10
# Load kernel image
load mmc 0:1 ${kernel_addr_r} boot/Image
# Load DTB file
load mmc 0:1 ${fdt_addr_r} boot/dtb/allwinner/sun50i-h618-orangepi-zero3.dtb
# Boot
booti ${kernel_addr_r} - ${fdt_addr_r}
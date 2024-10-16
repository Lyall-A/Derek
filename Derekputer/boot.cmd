setenv bootargs console=ttyS0,115200 root=/dev/mmcblk0p1 rootwait panic=10
load mmc 0:1 ${kernel_addr_r} boot/Image
load mmc 0:1 ${fdt_addr_r} boot/sun50i-h618-orangepi-zero3.dtb
booti ${kernel_addr_r} - ${fdt_addr_r}
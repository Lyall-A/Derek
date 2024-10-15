#!/bin/bash

sudo qemu-system-aarch64 \
    -M virt \
    -cpu cortex-a57 \
    -m 1024 \
    -nographic \
    -bios ./u-boot.bin \
    -dtb ./qemu.dtb \
    -kernel ../Image \
    -append "root=/dev/vda rw console=ttyAMA0" \
    -drive file=./derek-os.img,if=virtio,format=raw,id=hd0
    # -append "root=/dev/vdb rw console=ttyAMA0" \
    # -drive file=./boot.img,if=virtio,format=raw,id=hd0 \
    # -drive file=./root.img,if=virtio,format=raw,id=hd1

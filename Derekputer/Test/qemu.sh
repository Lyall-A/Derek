#!/bin/bash

sudo qemu-system-aarch64 \
    -M virt \
    -cpu cortex-a57 \
    -m 1024 \
    -nographic \
    -bios ./u-boot.bin \
    -dtb ./qemu.dtb \
    -kernel ../Image.gz \
    -append "root=/dev/vda rw console=ttyAMA0" \
    -drive file=./derek-os.img,if=none,format=raw,id=hd0 \
    -device virtio-blk-device,drive=hd0
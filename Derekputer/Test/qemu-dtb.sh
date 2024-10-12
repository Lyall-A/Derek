#!/bin/bash

qemu-system-aarch64 \
    -M virt \
    -cpu cortex-a57 \
    -m 1024 \
    -nographic \
    -bios ./u-boot.bin \
    -kernel ../Image.gz \
    -append "root=/dev/vda console=ttyAMA0 rw" \
    -drive file=./derek-os.img,if=none,format=raw,id=hd0 \
    -device virtio-blk-device,drive=hd0 \
    -M dumpdtb=./qemu.dtb
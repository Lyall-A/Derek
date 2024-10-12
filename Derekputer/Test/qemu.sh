#!/bin/bash

qemu-system-aarch64 \
    -M virt \
    -cpu cortex-a57 \
    -m 1024 \
    -nographic \
    -bios ./u-boot.bin \
    -dtb ./qemu.dtb \
    -kernel ../Image.gz \
    -append "root=/dev/vda console=ttyAMA0 rw" \
    -drive file=./boot.img,if=none,format=raw,id=hd0 \
    -device virtio-blk-device,drive=hd0 \
    -drive file=./root.img,if=none,format=raw,id=hd1 \
    -device virtio-blk-device,drive=hd1 \
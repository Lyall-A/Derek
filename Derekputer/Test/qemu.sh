#!/bin/bash

sudo mount ./derek-os.img ./Mount

sudo qemu-system-aarch64 \
    -M virt \
    -cpu cortex-a57 \
    -m 1024 \
    -nographic \
    -bios ./u-boot.bin \
    -dtb ./qemu.dtb \
    -kernel ../Image.gz \
    -append "root=/dev/vda2 rw console=ttyAMA0" \
    -drive file=./boot.img,if=none,format=raw,id=hd0 \
    -device virtio-blk-device,drive=hd0 \
    -drive file=./root.img,if=none,format=raw,id=hd1 \
    -device virtio-blk-device,drive=hd1

sudo umount ./Mount
#!/bin/bash

qemu-system-aarch64 \
    -M virt \
    -cpu cortex-a57 \
    -bios ./u-boot.bin \
    -M dumpdtb=./qemu.dtb
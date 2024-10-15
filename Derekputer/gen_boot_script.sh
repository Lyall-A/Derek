#!/bin/bash
# Generates boot.scr

mkimage -C none -A arm64 -T script -d ./boot.cmd ./boot.scr
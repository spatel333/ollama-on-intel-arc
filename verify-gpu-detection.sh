#!/bin/bash

lspci -nn | grep -Ei 'VGA|DISPLAY'
uname -r
ls /dev/dri

sudo intel_gpu_top -d pci:vendor=8086,device=E20B,card=0
dmesg | grep -i intel
#!/bin/bash
# Runs oneshell.iso in QEMU in a phone-shaped window (the shell scales to any window size).
ISO=${1:-oneshell.iso}
ACCEL=$(test -w /dev/kvm && echo "-enable-kvm -cpu host" || echo "-cpu max")   # macOS: use -accel hvf; Windows: -accel whpx
exec qemu-system-x86_64 $ACCEL -m 3G -smp 4 -cdrom "$ISO" -boot d \
  -device virtio-vga -display gtk,zoom-to-fit=on \
  -device qemu-xhci -device usb-tablet -device intel-hda -device hda-duplex -nic user

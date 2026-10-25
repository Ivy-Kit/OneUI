@echo off
REM Runs oneshell.iso in QEMU on Windows. Put oneshell.iso next to this file.
REM Install QEMU first:  winget install SoftwareFreedomConservancy.QEMU
set QEMU="C:\Program Files\qemu\qemu-system-x86_64.exe"
set ISO=%~dp0oneshell.iso
if not exist %QEMU% (echo QEMU not found. Run: winget install SoftwareFreedomConservancy.QEMU & pause & exit /b)
if not exist "%ISO%" (echo oneshell.iso not found next to this script. & pause & exit /b)

REM Fast mode (needs Windows feature "Windows Hypervisor Platform"). Falls back to slow mode if it fails.
%QEMU% -accel whpx,kernel-irqchip=off -m 3G -smp 4 -cdrom "%ISO%" -boot d -device virtio-vga -display gtk,zoom-to-fit=on -device qemu-xhci -device usb-tablet -nic user
if errorlevel 1 %QEMU% -accel tcg -m 3G -smp 2 -cdrom "%ISO%" -boot d -device virtio-vga -display gtk,zoom-to-fit=on -device qemu-xhci -device usb-tablet -nic user

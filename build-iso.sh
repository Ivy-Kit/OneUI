#!/bin/bash
# Builds oneshell.iso: boots straight into the phone shell (./shell/index.html)
# Run on a Debian/Ubuntu machine:  sudo ./build-iso.sh   (needs internet, ~3GB disk)
# Test:  ./run-qemu.sh
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get install -y --no-install-recommends live-build debootstrap debian-archive-keyring

rm -rf build && mkdir build && cd build

lb config \
  --distribution bookworm \
  --architectures amd64 \
  --binary-images iso-hybrid \
  --mirror http://deb.debian.org/debian \
  --security-mirror http://deb.debian.org/debian-security \
  --archive-areas "main contrib non-free-firmware" \
  --bootappend-live "boot=live quiet splash" \
  --debian-installer none

echo "linux-image-amd64 live-boot systemd-sysv cage chromium seatd fonts-roboto fonts-noto-color-emoji mesa-vulkan-drivers xwayland network-manager libpam-systemd dbus" \
  > config/package-lists/os.list.chroot
# the shell lives here -> edit shell/index.html, rebuild, done
mkdir -p config/includes.chroot/opt/shell config/includes.chroot/etc/systemd/system/getty@tty1.service.d config/includes.chroot/etc/skel
cp ../shell/index.html config/includes.chroot/opt/shell/index.html
cat > config/includes.chroot/etc/systemd/system/getty@tty1.service.d/autologin.conf <<'X'
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin user --noclear %I $TERM
X
cat > config/includes.chroot/etc/skel/.profile <<'X'
if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = /dev/tty1 ]; then
  export XDG_RUNTIME_DIR=/run/user/$(id -u); mkdir -p $XDG_RUNTIME_DIR
  export WLR_RENDERER=pixman WLR_NO_HARDWARE_CURSORS=1 LIBSEAT_BACKEND=builtin
  exec cage -s -- chromium --disable-gpu --kiosk --no-sandbox --user-data-dir=/home/user/.cr \
    --ozone-platform=wayland --disable-infobars --noerrdialogs \
    --allow-file-access-from-files file:///opt/shell/index.html
fi
X
mkdir -p config/hooks/live
cat > config/hooks/live/01-user.hook.chroot <<'X'
#!/bin/sh
useradd -m -s /bin/bash -G video,audio,input,render,seat user || true
echo "user:user" | chpasswd
X
chmod +x config/hooks/live/01-user.hook.chroot
lb build
mv live-image-amd64.hybrid.iso ../oneshell.iso && echo "Done: oneshell.iso"

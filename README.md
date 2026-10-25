# OneShell: One UI-style phone OS starter
Linux kernel (Debian live) -> Cage -> Chromium kiosk -> `shell/index.html` (the entire phone UI, 400x866, scales to any window).

## Try the UI instantly
Open `shell/index.html` in a browser. Swipe (drag) up from the bottom for the app drawer, down from the top for quick panel, up on the lock screen to unlock. Nav buttons: recents / home / back.

## Get the bootable image (.iso) without owning a Linux box
1. Create a GitHub repo, upload this folder (keep `.github/`).
2. Actions tab -> "Build ISO" -> Run workflow. ~15 min.
3. Download `oneshell-iso` artifact, unzip -> `oneshell.iso`.
Or on Debian/Ubuntu: `sudo ./build-iso.sh`.

## Run in QEMU
Windows: double-click `run-qemu.bat` (needs `winget install SoftwareFreedomConservancy.QEMU`). Linux: `./run-qemu.sh`.

## Customize
Settings app (accent, dark mode, roundness, wallpaper, name) or `CONFIG` at the top of `shell/index.html`. New app = one line in `CONFIG.apps`; custom behavior = a function in `TYPES`. Rebuild the ISO to ship changes.

Not affiliated with Samsung; no Samsung logos, fonts or assets are used.

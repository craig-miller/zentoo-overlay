# zentoo-overlay

A Gentoo Portage overlay for packages not in the main tree or GURU, maintained alongside the [zentoo install guide](https://github.com/craig-miller/zentoo) — a Gentoo Linux install guide for Apple Silicon (M1) MacBooks running Asahi.

## Packages

| Package                                       | Purpose                                                                                                                                      |
| --------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| `app-laptop/asahi-brightnessd`                | C daemon driving display + keyboard backlight from the M1 ambient-light sensor ([source](https://github.com/craig-miller/asahi-brightnessd)) |
| `app-misc/vimb-blocklist`                     | WebKit-native ad + tracker + cookie-banner blocking for vimb: weekly refresh cron + C compile binary ([source](https://github.com/craig-miller/vimb-blocklist)) |
| `app-misc/zentoo-ndi-cast`                    | Helper that broadcasts the desktop as an NDI source on the LAN, paired with the [`zentoo/ndi_sender`](https://github.com/craig-miller/zentoo-noctalia-plugins) Noctalia plugin |
| `app-portage/pycargoebuild`                   | Local backport of pycargoebuild ahead of the main tree                                                                                       |
| `dev-util/adblock-rust-cli`                   | Convert EasyList/ABP filter lists to Apple WKContentRuleList JSON; feeds `app-misc/vimb-blocklist` ([source](https://github.com/craig-miller/adblock-rust-cli)) |
| `gui-apps/noctalia-greeter`                   | Noctalia-matching login UI for greetd ([source](https://github.com/noctalia-dev/noctalia-greeter))                                           |
| `gui-apps/noctalia-shell`                     | Material You Wayland shell ([source](https://github.com/noctalia-dev/noctalia-shell))                                                        |
| `gui-apps/soundthemed`                        | Freedesktop sound-theme daemon ([source](https://github.com/destructatron/soundthemed))                                                      |
| `sys-boot/grub`                               | Patched GRUB silencing `Loading Linux ...` / `Loading initial ramdisk ...` echoes for the install guide's quiet-boot chain                   |
| `sys-boot/u-boot`                             | Patched Asahi U-Boot, silenced console + framebuffer output, zero autoboot delay, for the install guide's quiet-boot chain                   |
| `www-client/vimb`                             | Fast vim-like WebKitGTK browser, patched against `net-libs/webkit-gtk:6` + `gui-libs/gtk:4` with native content-filter loading                |
| `x11-themes/plymouth-theme-spinfinity-zentoo` | Plymouth boot theme — centered infinity spinner with white pill LUKS entry on black background                                               |

## Enabling

```
sudo vi /etc/portage/repos.conf/zentoo.conf
```

Paste:

```
[zentoo]
location = /var/db/repos/zentoo
sync-type = git
sync-uri = https://github.com/craig-miller/zentoo-overlay.git
auto-sync = yes
```

Sync:

```
sudo emaint -r zentoo sync
```

## License

This overlay is distributed under the [GNU General Public License v2](LICENSE). Individual ebuilds carry the upstream package's own license — see each ebuild's `LICENSE=` field.

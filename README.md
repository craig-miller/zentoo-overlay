# zentoo-overlay

A Gentoo Portage overlay for packages not in the main tree or GURU, maintained alongside the [zentoo install guide](https://github.com/craig-miller/zentoo) — a Gentoo Linux install guide for Apple Silicon (M1) MacBooks running Asahi.

## Packages

| Package | Purpose |
| --- | --- |
| `app-laptop/asahi-brightnessd` | C daemon driving display + keyboard backlight from the M1 ambient-light sensor ([source](https://github.com/craig-miller/asahi-brightnessd)) |
| `app-portage/pycargoebuild` | Local backport of pycargoebuild ahead of the main tree |
| `dev-lang/dart-sass-bin` | Dart Sass compiler (binhost) |
| `gui-apps/danksearch` | App-launcher backend used by DankMaterialShell |
| `gui-apps/soundthemed` | Userspace sound-theme daemon ([source](https://github.com/craig-miller/soundthemed)) |
| `gui-apps/wayle` | Wayland desktop shell — bar, OSD, notifications, wallpaper, device controls ([upstream](https://github.com/wayle-rs/wayle)) |

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

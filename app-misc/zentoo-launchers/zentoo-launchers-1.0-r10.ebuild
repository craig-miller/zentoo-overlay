# Copyright 2026 Craig Miller
# Distributed under the terms of the MIT License

EAPI=8

inherit desktop

DESCRIPTION="Custom XDG launcher entries for zentoo (Open Camera, etc.)"
HOMEPAGE="https://github.com/craig-miller/zentoo-overlay"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~arm64"

# Each .desktop file in files/ lands in /usr/share/applications/ and is
# picked up by noctalia's launcher (and any other XDG-compliant menu).
# Add new entries by dropping a .desktop into files/ and revbumping.
# Runtime deps for the apps the launchers invoke are unioned here so
# removing them surfaces via portage.
RDEPEND="
	media-video/mpv
	app-admin/pass-otp
	net-dns/avahi
	net-fs/samba
	gui-apps/wl-clipboard
	gnome-base/gvfs
     media-sound/qobuz-player
"

src_install() {
	domenu "${FILESDIR}"/*.desktop
	dobin "${FILESDIR}"/network-browser
}

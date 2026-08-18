# Copyright 2026 Craig Miller
# Distributed under the terms of the MIT License

EAPI=8

DESCRIPTION="Cross-cutting research/PKM tools: sioyek->typst highlights + card-list daemon"
HOMEPAGE="https://github.com/craig-miller/zentoo-overlay"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~arm64"

RDEPEND="
	app-text/sioyek
	dev-lang/python:*
	app-shells/bash
	app-misc/watchexec
"

src_install() {
	dobin "${FILESDIR}"/export-highlights
	dobin "${FILESDIR}"/research-cards-daemon

	insinto /etc/xdg/autostart
	doins "${FILESDIR}"/research-cards.desktop
}

pkg_postinst() {
	elog "To wire export-highlights into sioyek, add this line to"
	elog "~/.config/sioyek/prefs_user.config:"
	elog ""
	elog "  new_command _export_highlights /usr/bin/export-highlights %{file_path} %{shared_database} %{local_database}"
	elog ""
	elog "Then bind a key in ~/.config/sioyek/keys_user.config, e.g.:"
	elog ""
	elog "  _export_highlights Z"
	elog ""
	elog "Sioyek caches config at startup — restart it for changes to take effect."
	elog ""
	elog "research-cards-daemon auto-starts via /etc/xdg/autostart on next login"
	elog "(requires dex -a or an equivalent XDG autostart runner)."
}

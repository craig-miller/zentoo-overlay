# Copyright 2026 Craig Miller
# Distributed under the terms of the MIT License

EAPI=8

inherit toolchain-funcs git-r3

DESCRIPTION="Ad+tracker+cookie blocking for vimb via WebKit content filters"
HOMEPAGE="https://github.com/craig-miller/vimb-blocklist"

EGIT_REPO_URI="https://github.com/craig-miller/vimb-blocklist.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

DEPEND="
	net-libs/webkit-gtk:6
	dev-libs/glib:2
"

RDEPEND="
	${DEPEND}
	dev-util/adblock-rust-cli
	net-misc/curl
	sys-process/cronie
"

BDEPEND="virtual/pkgconfig"

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs
}

pkg_postinst() {
	elog ""
	elog "Refreshing /var/cache/vimb-blocklist/store (fetch + compile)."
	elog ""
	if /etc/cron.weekly/vimb-blocklist-refresh; then
		elog "Filters ready. vimb will attach them on next launch."
	else
		ewarn "Refresh failed — inspect the output above."
		ewarn "The weekly cron will retry; run manually with:"
		ewarn "  sudo /etc/cron.weekly/vimb-blocklist-refresh"
	fi
	elog ""
	elog "Refresh cadence: weekly via /etc/cron.weekly/vimb-blocklist-refresh."
	elog "EasyList / EasyPrivacy / EasyList Cookie List are refreshed atomically."
	elog ""
	elog "To disable ad-blocking without uninstalling, add to ~/.config/vimb/config:"
	elog "    set content-filter-store-path="
	elog ""
}

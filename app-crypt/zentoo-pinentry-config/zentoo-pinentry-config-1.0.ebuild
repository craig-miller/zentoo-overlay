EAPI=8

DESCRIPTION="Zentoo GPG pinentry auto-dispatch configuration"
HOMEPAGE="https://github.com/craig-miller/zentoo-overlay"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	app-crypt/gnupg
	app-crypt/pinentry[ncurses]
	app-crypt/pinentry-egui
"

src_install() {
	dobin "${FILESDIR}"/pinentry-auto

	insinto /etc/gnupg
	doins "${FILESDIR}"/gpg-agent.conf

	insinto /usr/share/fish/vendor_conf.d
	doins "${FILESDIR}"/90-gpg-agent-tty.fish

	insinto /etc/profile.d
	doins "${FILESDIR}"/90-gpg-agent-tty.sh
}

pkg_postinst() {
	elog "Installed /usr/bin/pinentry-auto, which uses pinentry-egui in Wayland"
	elog "sessions and falls back to pinentry-curses/pinentry-tty for SSH/TTY."
	elog ""
	elog "System gpg-agent defaults were installed to /etc/gnupg/gpg-agent.conf."
	elog "If a user has ~/.gnupg/gpg-agent.conf with pinentry-program set, that"
	elog "per-user config takes precedence and should be updated to:"
	elog "    pinentry-program /usr/bin/pinentry-auto"
	elog ""
	elog "Restart the agent after changing config:"
	elog "    gpgconf --kill gpg-agent"
}

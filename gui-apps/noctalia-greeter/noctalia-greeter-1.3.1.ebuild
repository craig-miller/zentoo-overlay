# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

MY_COMMIT="6379fe287bb02b0bb538ad155fe18b1bf8615daf"

DESCRIPTION="Login greeter matching the Noctalia Wayland shell"
HOMEPAGE="https://noctalia.dev/ https://github.com/noctalia-dev/noctalia-greeter"

SRC_URI="https://github.com/noctalia-dev/noctalia-greeter/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~arm64"

DEPEND="
	dev-cpp/nlohmann_json
	dev-cpp/tomlplusplus
	dev-libs/glib:2
	dev-libs/libinput
	dev-libs/stb
	dev-libs/wayland
	gnome-base/librsvg:2
	gui-libs/wlroots:0.20
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libwebp
	media-libs/mesa
	sys-auth/polkit
	x11-libs/cairo[glib]
	x11-libs/libxkbcommon
	x11-libs/pango
"

RDEPEND="${DEPEND}
	gui-libs/greetd
	sys-apps/dbus
	sys-apps/ripgrep
	sys-auth/elogind
"

BDEPEND="
	dev-libs/wayland-protocols
	dev-util/wayland-scanner
"

DOCS=( README.md )

src_install() {
	meson_src_install
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/logrotate ${PN}
}

pkg_postinst() {
	elog ""
	elog "noctalia-greeter is installed but the system still uses your"
	elog "current greetd greeter. To swap:"
	elog ""
	elog "  1. Back up /etc/greetd/config.toml and /etc/pam.d/greetd"
	elog "  2. sudo /usr/share/noctalia-greeter/setup_greeter_system.sh"
	elog "     (creates the 'greeter' system user, patches /etc/pam.d/greetd"
	elog "     with pam_elogind.so, sets up /var/lib/noctalia-greeter/)"
	elog "  3. Set /etc/greetd/config.toml [default_session]:"
	elog "       command = \"/usr/bin/noctalia-greeter-session\""
	elog "       user    = \"greeter\""
	elog "  4. sudo rc-service greetd restart"
	elog ""
	elog "Wallpaper/palette sync: noctalia panel -> Settings -> Shell ->"
	elog "Security -> Noctalia Greeter -> Sync Now."
}

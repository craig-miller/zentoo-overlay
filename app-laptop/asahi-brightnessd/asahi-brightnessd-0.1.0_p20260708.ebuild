# Copyright 2026 Craig Miller
# Distributed under the terms of the MIT License

EAPI=8

inherit toolchain-funcs

COMMIT="c8038a3562b79309932463966237d368a421d292"

DESCRIPTION="Ambient-light auto-brightness for display + keyboard backlight (Asahi Linux)"
HOMEPAGE="https://github.com/craig-miller/asahi-brightnessd"
SRC_URI="https://github.com/craig-miller/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~arm64"

# Pure C, libc only. Runtime requires:
#  - aop_als kernel module (CONFIG_IIO_AOP_SENSOR_ALS=m)
#  - apple/aop-als-cal.bin in /lib/firmware (extracted from macOS — see HOMEPAGE)
#  - apple-panel-bl backlight device
#  - kbd_backlight LED device
# All of these are present on Apple Silicon laptops running an Asahi kernel.

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" install
	newinitd "${S}/${PN}.openrc" "${PN}"
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/logrotate ${PN}
	einstalldocs
}

pkg_postinst() {
	elog ""
	elog "Enable the service:"
	elog "  rc-update add ${PN} default"
	elog "  rc-service  ${PN} start"
	elog ""
	elog "Requires apple/aop-als-cal.bin in /lib/firmware/apple/ — extract"
	elog "from a macOS ioreg dump using extract-als-cal.py from:"
	elog "  https://github.com/juicecultus/asahi-auto-brightness"
	elog ""
	elog "Bind XF86MonBrightnessUp/Down in your compositor to brightnessctl;"
	elog "the daemon detects external writes and yields the channel until"
	elog "ambient light shifts significantly. See ${HOMEPAGE} for details."
	elog ""
}

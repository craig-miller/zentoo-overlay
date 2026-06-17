# Copyright 2026 Craig Miller
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Plymouth theme: centered infinity spinner with pill LUKS entry on black"
HOMEPAGE="https://github.com/craig-miller/zentoo-overlay"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm64"

RDEPEND="sys-boot/plymouth"

src_install() {
	local theme_dir=/usr/share/plymouth/themes/spinfinity-zentoo

	insinto "${theme_dir}"
	doins "${FILESDIR}"/spinfinity-zentoo.plymouth
	doins "${FILESDIR}"/{background-tile,box,bullet,entry,lock}.png

	local f
	for f in animation-0001 capslock keyboard keymap-render; do
		dosym "../spinfinity/${f}.png" "${theme_dir}/${f}.png"
	done
	local n
	for n in {00..33}; do
		dosym "../spinfinity/throbber-${n}.png" "${theme_dir}/throbber-${n}.png"
	done
}

pkg_postinst() {
	elog "Activate this theme with:"
	elog ""
	elog "    plymouth-set-default-theme -R spinfinity-zentoo"
	elog ""
	elog "Throbber, keyboard and capslock assets are symlinked from the stock"
	elog "sys-boot/plymouth spinfinity theme; uninstalling that theme will"
	elog "break this one."
}

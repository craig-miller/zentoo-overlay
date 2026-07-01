# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

DESCRIPTION="Nord-colored icon theme (blue variant, standard + dark)"
HOMEPAGE="https://github.com/MolassesLover/Nordzy-icon"
SRC_URI="https://github.com/MolassesLover/Nordzy-icon/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Nordzy-icon-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~arm64"

RDEPEND="x11-themes/hicolor-icon-theme"

src_install() {
	dodir /usr/share/icons
	bash install.sh -d "${ED}/usr/share/icons" || die "install.sh failed"

	# Zentoo-flavor default: Nordzy-dark for dark-mode desktops.
	# User-scope gsettings and settings.ini values win when set.
	insinto /usr/share/glib-2.0/schemas
	doins "${FILESDIR}"/50_zentoo-nordzy.gschema.override

	insinto /etc/xdg/gtk-3.0
	doins "${FILESDIR}"/settings.ini

	insinto /etc/xdg/gtk-4.0
	doins "${FILESDIR}"/settings.ini
}

pkg_postinst() {
	xdg_pkg_postinst
	glib-compile-schemas "${EROOT}/usr/share/glib-2.0/schemas" 2>/dev/null || :
}

pkg_postrm() {
	xdg_pkg_postrm
	glib-compile-schemas "${EROOT}/usr/share/glib-2.0/schemas" 2>/dev/null || :
}

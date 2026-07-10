# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic meson

DESCRIPTION="UI library that focuses on simplicity and minimalism"
HOMEPAGE="https://pwmt.org/projects/girara/"
SRC_URI="https://github.com/pwmt/girara/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0/5.0" # SONAME (see meson.build)
KEYWORDS="~arm64"
IUSE="doc X"

RDEPEND="
	>=dev-libs/glib-2.72:2
	dev-libs/gobject-introspection
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( app-text/doxygen )
"

DOCS=( AUTHORS README.md )

src_configure() {
	use X || append-flags -DGENTOO_GTK_HIDE_X11

	local emesonargs=(
		$(meson_feature doc docs)
	)
	meson_src_configure
}

src_compile() {
	meson_src_compile
	use doc && HTML_DOCS=( "${BUILD_DIR}"/doc/html/. )
}

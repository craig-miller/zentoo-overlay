# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pwmt/zathura-pdf-mupdf.git"
	EGIT_BRANCH="develop"
	# Pin: upstream commit bfc8370a (2026-07-08) regressed the plugin
	# by removing VERSION_MAJOR/MINOR/REV — needed for zathura's new
	# 6-arg ZATHURA_PLUGIN_REGISTER_WITH_FUNCTIONS macro. Pinning to
	# 70f0e704 (2026-07-06), the last commit with correct version
	# handling. Drop this pin when upstream restores VERSION_MAJOR/etc.
	EGIT_COMMIT="70f0e704f3a679549e57d5e36faf949ee01a16b6"
else
	KEYWORDS="~arm64"
	SRC_URI="https://github.com/pwmt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="PDF support for zathura using the mupdf PDF rendering library"
HOMEPAGE="https://pwmt.org/projects/zathura-pdf-mupdf/"

LICENSE="ZLIB"
SLOT="0"

# Tests currently only validating data files
RESTRICT="test"

DEPEND="
	>=app-text/mupdf-1.26.0:=
	>=app-text/zathura-2026.07.08:=
	dev-libs/girara:=
	dev-libs/glib:2
	x11-libs/cairo
"

RDEPEND="${DEPEND}"

BDEPEND="virtual/pkgconfig"

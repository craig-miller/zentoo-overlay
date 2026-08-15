# Copyright 2026 Craig Miller
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 qmake-utils desktop xdg

# Sioyek vendors mupdf and zlib as git submodules; mupdf in turn vendors 17
# more submodules of its own (freetype, harfbuzz, jbig2dec, jpeg, lcms2mt,
# mujs, openjpeg, gumbo-parser, brotli, curl, freeglut, tesseract, leptonica,
# extract, zint, zxing-cpp, zlib). Several of those — most importantly
# thirdparty/lcms2 (Artifex's own lcms2mt MT-safe fork, not shipped in Gentoo)
# — must be present for mupdf's build to even find its headers. GitHub's
# archive/<sha>.tar.gz strips submodule contents, so vendoring via tarballs
# would need us to source every sub-submodule individually. git-r3 with
# EGIT_SUBMODULES=('*') does it recursively in one shot; the fetch is cached
# under /var/cache/git-r3 so subsequent rebuilds are fast.

DESCRIPTION="PDF viewer for research papers and technical books"
HOMEPAGE="https://github.com/ahrm/sioyek"

EGIT_REPO_URI="https://github.com/ahrm/sioyek.git"
EGIT_COMMIT="cd319eb4804115792ea3e8799dcb5c1332515460"
EGIT_SUBMODULES=( '*' )

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~arm64"

RDEPEND="
	dev-qt/qtbase:6[gui,network,opengl,widgets]
	dev-qt/qtdeclarative:6
	dev-qt/qtsvg:6
	dev-qt/qtspeech:6
	dev-qt/qt3d:6
	media-libs/harfbuzz
"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/qttools:6[linguist]"

src_compile() {
	# Build the vendored mupdf statically against the system harfbuzz; every
	# other thirdparty dep is populated from mupdf's own submodules. Restrict
	# to the "libs" target so make doesn't also try to build the mupdf-gl
	# GLUT viewer app, which sioyek doesn't link and which needs GL/GLU
	# headers we don't want to pull in.
	emake -C mupdf USE_SYSTEM_HARFBUZZ=yes verbose=yes libs libmupdf-threads

	# LINUX_STANDARD_PATHS makes sioyek honour /etc/sioyek for defaults,
	# /usr/share/sioyek for shaders + tutorial, and ~/.local/share/sioyek
	# for its databases — the FHS layout this install lays down below.
	eqmake6 \
		"CONFIG+=linux_app_image" \
		"DEFINES+=LINUX_STANDARD_PATHS" \
		pdf_viewer_build_config.pro
	emake
}

src_install() {
	dobin sioyek

	insinto /usr/share/sioyek
	doins tutorial.pdf

	insinto /usr/share/sioyek/shaders
	doins pdf_viewer/shaders/*

	insinto /etc/sioyek
	doins pdf_viewer/prefs.config pdf_viewer/keys.config

	newicon resources/sioyek-icon-linux.png sioyek.png
	domenu "${FILESDIR}/sioyek.desktop"
	doman resources/sioyek.1
}

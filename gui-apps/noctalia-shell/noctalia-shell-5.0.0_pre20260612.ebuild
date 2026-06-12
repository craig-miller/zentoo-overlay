# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson optfeature

MY_COMMIT="2070b4b70cd78931cbf87439acc2cc6dbdff4174"

DESCRIPTION="A lightweight Wayland shell and bar built directly on Wayland + OpenGL ES"
HOMEPAGE="https://noctalia.dev/ https://github.com/noctalia-dev/noctalia"

SRC_URI="https://github.com/noctalia-dev/noctalia/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/noctalia-${MY_COMMIT}"

LICENSE="MIT"
SLOT="0"

IUSE="+jemalloc"

DEPEND="
	dev-libs/glib:2
	dev-cpp/sdbus-c++
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libwebp
	gnome-base/librsvg:2
	media-video/pipewire
	net-misc/curl
	sys-libs/pam
	x11-libs/cairo[glib]
	x11-libs/pango
	x11-libs/libxkbcommon
	media-libs/mesa
	sci-libs/libqalculate
	virtual/opengl
	dev-libs/wayland
	sys-auth/polkit
	jemalloc? ( dev-libs/jemalloc:= )
"

RDEPEND="${DEPEND}"

BDEPEND="
	dev-libs/wayland
	dev-libs/wayland-protocols
	dev-util/wayland-scanner
"

DOCS=( README.md CREDITS.md example.toml )

src_configure() {
	local emesonargs=(
			$(meson_feature jemalloc)
	)
	meson_src_configure
}

pkg_postinst() {
	optfeature "external display brightness control" app-misc/ddcutil
	optfeature "hardware-accelerated screen recording" media-video/gpu-screen-recorder
	optfeature "greeter sync (matching login screen)" gui-apps/noctalia-greeter
}

# Copyright 2026 Craig Miller
# Distributed under the terms of the MIT License

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit python-single-r1

DESCRIPTION="Broadcast the local desktop as an NDI source over the LAN"
HOMEPAGE="https://github.com/craig-miller/zentoo-overlay"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~arm64"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Runtime requires PipeWire screencast via xdg-desktop-portal (gnome backend),
# gst-launch-1.0 with capssetter (gst-plugins-bad) + ndisink (gst-plugin-ndi),
# and the dbus-python + pygobject bindings under the same Python slot.
RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	')
	media-libs/gstreamer
	media-libs/gst-plugins-base
	media-libs/gst-plugins-bad
	media-plugins/gst-plugin-ndi
	sys-apps/xdg-desktop-portal-gnome
"

src_install() {
	python_setup
	python_doscript "${FILESDIR}/zentoo-ndi-cast"
}

# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Forked from GURU's gui-wm/niri-26.04.ebuild. Pins niri to upstream PR #1791
# HEAD commit (6c1613ce), which adds SHM (shared-memory) fallback for the
# PipeWire screencast stream. Required on Asahi-Gentoo: niri's default
# DMA-BUF-only screencast stream uses the Apple-tiled-compressed modifier,
# which decodes correctly through libwebrtc but not through gst-plugins-base.
# The SHM fallback gives gstreamer (and any other non-libwebrtc consumer) a
# universal modifier-less code path.
#
# Version 9999_p20260628 reads "live (9999) snapshot pinned to 2026-06-28".
# The 9999 in the PV satisfies cargo.eclass's live-only gate around
# cargo_live_src_unpack while still pinning to a specific commit via SRC_URI.
#
# Drop this ebuild once PR #1791 merges and reaches a tagged release.
# Upstream PR: https://github.com/YaLTeR/niri/pull/1791

EAPI=8

CRATES=""

LLVM_COMPAT=( {19..22} )
RUST_MIN_VER="1.87.0"

inherit cargo llvm-r2 optfeature shell-completion systemd

DESCRIPTION="Scrollable-tiling Wayland compositor (PR #1791 SHM screencast)"
HOMEPAGE="https://github.com/niri-wm/niri"

# PR head commit; fetched as a GitHub archive tarball since PR refs aren't
# directly addressable through git-r3.
NIRI_COMMIT="6c1613cee488515f3021ae9d8ef9233d6719c13f"
SRC_URI="https://github.com/niri-wm/niri/archive/${NIRI_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/niri-${NIRI_COMMIT}"

# Pretty commit-id for `niri --version`
export NIRI_BUILD_COMMIT="${NIRI_COMMIT:0:8}"

LICENSE="GPL-3+"
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD ISC MIT MPL-2.0
	Unicode-3.0 ZLIB
"
SLOT="0"
# Live to disable network-sandbox during src_unpack (cargo fetches crates).
PROPERTIES="live"
IUSE="+dbus screencast systemd"
REQUIRED_USE="
	screencast? ( dbus )
	systemd? ( dbus )
"

DEPEND="
	dev-libs/glib:2
	dev-libs/libinput:=
	dev-libs/wayland
	<media-libs/libdisplay-info-0.4.0:=
	media-libs/mesa
	sys-auth/seatd:=
	virtual/libudev:=
	x11-libs/cairo
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman
	screencast? ( media-video/pipewire:= )
"
RDEPEND="
	${DEPEND}
	screencast? ( sys-apps/xdg-desktop-portal-gnome )
"
BDEPEND="
	screencast? ( $(llvm_gen_dep 'llvm-core/clang:${LLVM_SLOT}') )
"

ECARGO_VENDOR="${WORKDIR}/vendor"

QA_FLAGS_IGNORED="usr/bin/niri"

pkg_setup() {
	llvm-r2_pkg_setup
	rust_pkg_setup
}

src_unpack() {
	default
	cargo_live_src_unpack
}

src_prepare() {
	sed -i \
		-e 's/git = "[^ ]*"/version = "*"/' \
		-e '/rev =/d' \
		Cargo.toml || die
	if ! use systemd; then
		local cmd="niri --session"
		use dbus && cmd="dbus-run-session $cmd"
		sed -i "s/niri-session/$cmd/" resources/niri.desktop || die
	fi
	default
}

src_configure() {
	local myfeatures=(
		$(usev dbus)
		$(usev screencast xdp-gnome-screencast)
		$(usev systemd)
	)
	cargo_src_configure --no-default-features
}

src_compile() {
	cargo_src_compile

	"$(cargo_target_dir)"/niri completions bash > niri  || die
	"$(cargo_target_dir)"/niri completions fish > niri.fish || die
	"$(cargo_target_dir)"/niri completions zsh > _niri || die
}

src_install() {
	cargo_src_install

	dobin resources/niri-session
	systemd_douserunit resources/niri{.service,-shutdown.target}

	insinto /usr/share/wayland-sessions
	doins resources/niri.desktop

	insinto /usr/share/xdg-desktop-portal
	doins resources/niri-portals.conf

	dobashcomp niri
	dofishcomp niri.fish
	dozshcomp _niri
}

pkg_postinst() {
	optfeature "Xwayland support" "gui-apps/xwayland-satellite"
}

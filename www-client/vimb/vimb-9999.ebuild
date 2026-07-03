# Copyright 2026 zentoo
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit savedconfig flag-o-matic git-r3

DESCRIPTION="A fast, lightweight, vim-like browser based on webkit (GTK4)"
HOMEPAGE="https://fanglingsu.github.io/vimb/"
# zentoo fork: WebKit content filters + opinionated defaults, rebased
# onto fanglingsu/vimb master periodically. See the fork's zentoo branch
# git log for the delta.
EGIT_REPO_URI="https://github.com/craig-miller/vimb.git"
EGIT_BRANCH="zentoo"

# Bundled Dark Reader library — installed to /usr/share/vimb/scripts.js
# as the system-default userscript. The fork's user_scripts() falls back
# to this path when a user ~/.config/vimb/scripts.js is absent (see fork
# commit 306069d). Bump this + re-emerge to test upstream releases before
# shipping.
DARKREADER_VER="4.9.128"
SRC_URI="https://registry.npmjs.org/darkreader/-/darkreader-${DARKREADER_VER}.tgz -> darkreader-${DARKREADER_VER}.tgz"

# GPL-3 for vimb itself and the fork sources; MIT for the bundled Dark
# Reader library file. Mere aggregation — the licenses coexist in one
# distribution package without derivative-work interaction.
LICENSE="GPL-3 MIT"
SLOT="0"
IUSE="savedconfig"

# WebKitGTK's media pipeline goes through GStreamer. Required plugin set
# for a working browser on YouTube + general streaming sites:
#
#   Core / codecs:
#   - gst-plugins-good: core elements (demuxers, parsers, autoaudiosink)
#   - gst-plugins-libav: H.264/AAC/VP9/AV1 codecs via ffmpeg/libav
#   - gst-plugins-opus: native Opus decoder (rank=primary), YouTube audio
#
#   HTTPS transport (required by HLS/DASH chunk fetch AND by any WebKit
#   <video src="https://..."> element — the majority of the web):
#   - gst-plugins-soup: souphttpsrc URI handler. Without it the pipeline
#     fails to preroll ("No URI handler implemented for https") and the
#     page's load event blocks — the whole tab hangs. Fixed 2026-07-01
#     after diagnosing an nextidea.io <video> stall.
#
#   Adaptive streaming (required for YouTube full videos, NOT shorts):
#   - gst-plugins-adaptivedemux2: framework
#   - gst-plugins-dash: DASH demuxer — YouTube full videos crash without it
#   - gst-plugins-hls: HLS demuxer — Apple-style streaming
#
#   Audio output:
#   - gst-plugins-pulse: pulsesink. Required for audio inside WebKit's
#     bubblewrap sandbox. WebKitGTK 2.50.5 binds the pulse socket via
#     bindPulse() in BubblewrapLauncher; pipewiresink, though it exists
#     in the registry, does not produce working audio from inside the
#     sandbox. The FIXME in WebKit source ("move to Pipewire as soon as
#     viable") indicates the pulse path is the intended one for now;
#     native pipewiresink support is planned but not yet shipped.
#   - pipewire[gstreamer]: still useful for system-wide GStreamer apps
#     outside the WebKit sandbox.
DEPEND="
	net-libs/webkit-gtk:6
	gui-libs/gtk:4
	media-libs/gst-plugins-good
	media-plugins/gst-plugins-libav
	media-plugins/gst-plugins-opus
	media-plugins/gst-plugins-soup
	media-plugins/gst-plugins-pulse
	media-plugins/gst-plugins-adaptivedemux2
	media-plugins/gst-plugins-dash
	media-plugins/gst-plugins-hls
	media-video/pipewire[gstreamer]
"
BDEPEND="virtual/pkgconfig"
RDEPEND="
	${DEPEND}
	app-misc/vimb-blocklist
"

src_unpack() {
	# git-r3 clones the fork into ${WORKDIR}/${P}; the DR tarball unpacks
	# to ${WORKDIR}/package/ (npm convention).
	git-r3_src_unpack
	default
}

src_prepare() {
	default
	restore_config config.def.h
}

src_compile() {
	# GTK4 has no XEmbed; keep the flag set unconditionally. Upstream
	# concern (not zentoo policy), so it stays in the ebuild rather
	# than in the fork's source.
	append-cflags -DFEATURE_NO_XEMBED=1
	emake PREFIX="/usr"
}

src_install() {
	emake PREFIX="/usr" DESTDIR="${D}" install
	einstalldocs

	# Helper for noctalia's [hooks].theme_mode_changed: takes dark|light
	# on argv OR via $NOCTALIA_THEME_MODE env, rewrites the vimb config's
	# `set dark-mode=` line, and pkill -USR2 -x vimb to reload the live
	# session.  Wired up in ~/.config/noctalia/vimb-hook.toml.
	dobin "${FILESDIR}/vimb-theme-flip"

	# System-default userscript: Dark Reader library concatenated with
	# the fork's bootstrap (DarkReader.auto() call). The fork's
	# user_scripts() falls back to this when ~/.config/vimb/scripts.js
	# is absent. Users disable by touching an empty file at that path.
	insinto /usr/share/vimb
	newins - scripts.js < <(cat "${WORKDIR}/package/darkreader.js" \
		"${S}/resources/scripts-bootstrap.js")

	# System-default config: dark-mode=on, stylesheet=off, zm binding.
	# Sourced by the fork's main.c before ~/.config/vimb/config, so user
	# config overrides any of these values.
	insinto /etc/vimb
	newins "${S}/resources/etc-vimb-config" config

	save_config src/config.def.h
}

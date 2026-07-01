# Copyright 2026 zentoo
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit savedconfig flag-o-matic git-r3

DESCRIPTION="A fast, lightweight, vim-like browser based on webkit (GTK4)"
HOMEPAGE="https://fanglingsu.github.io/vimb/"
EGIT_REPO_URI="https://github.com/fanglingsu/vimb.git"

LICENSE="GPL-3"
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
RDEPEND="${DEPEND}"

src_prepare() {
	default
	restore_config config.def.h
}

src_compile() {
	# GTK4 has no XEmbed; keep the flag set unconditionally.
	append-cflags -DFEATURE_NO_XEMBED=1
	emake PREFIX="/usr"
}

src_install() {
	emake PREFIX="/usr" DESTDIR="${D}" install
	einstalldocs
	save_config src/config.def.h
}

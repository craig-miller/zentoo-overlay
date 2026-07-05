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

# Bundled Dark Reader library — installed to /usr/share/vimb/darkreader.js as
# the DR-treatment engine when USE=dark-reader. The fork's user_scripts()
# picks up the concatenated /usr/share/vimb/scripts.js (DR library + fork
# bootstrap) as a fallback, and the dr-fixes tooling shipped alongside writes
# a fixes-DB-aware /var/lib/vimb/scripts.js via a weekly cron. Bump this + re-
# emerge to test upstream releases before shipping.
DARKREADER_VER="4.9.128"
SRC_URI="dark-reader? (
	https://registry.npmjs.org/darkreader/-/darkreader-${DARKREADER_VER}.tgz
)"

# GPL-3 for vimb itself and the fork sources; MIT for the bundled Dark
# Reader library file. Mere aggregation — the licenses coexist in one
# distribution package without derivative-work interaction.
LICENSE="GPL-3 dark-reader? ( MIT )"
SLOT="0"
IUSE="savedconfig +dark-reader"

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
	app-admin/pass
	app-misc/vimb-blocklist
	dark-reader? ( sys-process/cronie )
"

src_unpack() {
	# git-r3 clones the fork into ${WORKDIR}/${P}. When USE=dark-reader the
	# DR tarball also unpacks to ${WORKDIR}/package/ (npm convention).
	git-r3_src_unpack
	use dark-reader && default
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

	# System-default config: dark-mode=on + zm binding. Ships regardless of
	# dark-reader USE — `set dark-mode=on` broadcasts prefers-color-scheme=dark
	# to WebKit, an opinionated zentoo baseline independent of Dark Reader.
	insinto /etc/vimb
	newins "${S}/resources/etc-vimb-config" config

	if use dark-reader; then
		# Dark Reader library — installed standalone so the dr-fixes
		# refresh script can concatenate it with a fixes-aware bootstrap
		# and write the result to /var/lib/vimb/scripts.js. Also the left
		# half of the fixes-free baseline scripts.js below.
		insinto /usr/share/vimb
		newins "${WORKDIR}/package/darkreader.js" darkreader.js

		# Baseline userscript: DR library + the fork's fixes-free bootstrap.
		# The fork's user_scripts() picks this up via SYSTEM_SCRIPT when
		# neither ~/.config/vimb/scripts.js nor /var/lib/vimb/scripts.js
		# exists. Users disable DR entirely by touching an empty file at
		# ~/.config/vimb/scripts.js.
		newins - scripts.js < <(cat "${WORKDIR}/package/darkreader.js" \
			"${S}/resources/scripts-bootstrap.js")

		# Dark Reader fixes-DB tooling: refresh script + bootstrap template
		# + weekly cron. The refresh writes a fixes-aware scripts.js to
		# /var/lib/vimb/scripts.js, which the fork's user_scripts() picks
		# up via SYSTEM_SCRIPT_LOCAL (fork commit 42cb85c).
		exeinto /usr/libexec
		newexe "${S}/resources/dr-fixes/refresh" vimb-dr-fixes-refresh

		insinto /usr/share/vimb-dr-fixes
		doins "${S}/resources/dr-fixes/bootstrap.js"

		exeinto /etc/cron.weekly
		newexe "${S}/resources/dr-fixes/weekly-cron" vimb-dr-fixes

		# Pre-create the state directory so refresh doesn't need to mkdir
		# on first run (and so Portage tracks the ownership).
		keepdir /var/lib/vimb
	fi

	save_config src/config.def.h
}

pkg_postinst() {
	if use dark-reader; then
		elog ""
		elog "Refreshing /var/lib/vimb/scripts.js (fetch + parse Dark Reader fixes)."
		elog ""
		if /usr/libexec/vimb-dr-fixes-refresh; then
			elog "Fixes ready. vimb will pick them up on next launch."
		else
			ewarn "Refresh failed — inspect the output above."
			ewarn "The weekly cron will retry; run manually with:"
			ewarn "  sudo /etc/cron.weekly/vimb-dr-fixes"
		fi
		elog ""
		elog "Refresh cadence: weekly via /etc/cron.weekly/vimb-dr-fixes."
		elog "Anacron handles missed runs on wake (cronie[+anacron])."
		elog ""
		elog "To disable Dark Reader without uninstalling, run:"
		elog "    touch ~/.config/vimb/scripts.js"
		elog ""
	fi
}

pkg_postrm() {
	# pkg_postinst writes /var/lib/vimb/scripts.js from the fetched fixes;
	# we own it, so we clean it up. Guard on REPLACED_BY_VERSION so an
	# upgrade doesn't churn the file between old-postrm and new-postinst.
	if [[ -z ${REPLACED_BY_VERSION} ]]; then
		rm -f "${ROOT}/var/lib/vimb/scripts.js"
		rmdir --ignore-fail-on-non-empty "${ROOT}/var/lib/vimb" 2>/dev/null || true
	fi
}

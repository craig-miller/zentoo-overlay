# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	android_system_properties@0.1.5
	anyhow@1.0.102
	atomic_refcell@0.1.14
	autocfg@1.5.0
	bitflags@2.11.1
	bumpalo@3.20.2
	byte-slice-cast@1.2.3
	byteorder@1.5.0
	cc@1.2.62
	cfg-expr@0.17.2
	cfg-if@1.0.4
	chrono@0.4.44
	core-foundation-sys@0.8.7
	data-encoding@2.11.0
	either@1.15.0
	equivalent@1.0.2
	find-msvc-tools@0.1.9
	futures-channel@0.3.32
	futures-core@0.3.32
	futures-executor@0.3.32
	futures-macro@0.3.32
	futures-task@0.3.32
	futures-util@0.3.32
	gio-sys@0.22.0
	glib-macros@0.22.6
	glib-sys@0.22.6
	glib@0.22.7
	gobject-sys@0.22.6
	gst-plugin-version-helper@0.8.3
	gstreamer-audio-sys@0.25.2
	gstreamer-audio@0.25.2
	gstreamer-base-sys@0.25.0
	gstreamer-base@0.25.2
	gstreamer-sys@0.25.2
	gstreamer-video-sys@0.25.2
	gstreamer-video@0.25.2
	gstreamer@0.25.2
	hashbrown@0.17.1
	heck@0.5.0
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.65
	indexmap@2.14.0
	itertools@0.14.0
	js-sys@0.3.98
	kstring@2.0.2
	libc@0.2.186
	libloading@0.9.0
	log@0.4.29
	memchr@2.8.0
	muldiv@1.0.1
	num-integer@0.1.46
	num-rational@0.4.2
	num-traits@0.2.19
	once_cell@1.21.4
	option-operations@0.6.1
	pastey@0.2.2
	pin-project-lite@0.2.17
	pkg-config@0.3.33
	proc-macro2@1.0.106
	quick-xml@0.39.4
	quote@1.0.45
	rustversion@1.0.22
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_spanned@1.1.1
	shlex@1.3.0
	slab@0.4.12
	smallvec@1.15.1
	static_assertions@1.1.0
	syn@2.0.117
	system-deps@7.0.8
	target-lexicon@0.12.16
	thiserror-impl@2.0.18
	thiserror@2.0.18
	toml@1.1.2+spec-1.1.0
	toml_datetime@0.7.5+spec-1.1.0
	toml_datetime@1.1.1+spec-1.1.0
	toml_edit@0.23.10+spec-1.0.0
	toml_parser@1.1.2+spec-1.1.0
	toml_writer@1.1.1+spec-1.1.0
	unicode-ident@1.0.24
	version-compare@0.2.1
	wasm-bindgen-macro-support@0.2.121
	wasm-bindgen-macro@0.2.121
	wasm-bindgen-shared@0.2.121
	wasm-bindgen@0.2.121
	windows-core@0.62.2
	windows-implement@0.60.2
	windows-interface@0.59.3
	windows-link@0.2.1
	windows-result@0.4.1
	windows-strings@0.5.1
	windows-sys@0.52.0
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
	winnow@0.7.15
	winnow@1.0.2
"

inherit cargo rust-toolchain

DESCRIPTION="GStreamer plugin for NewTek/Vizrt NDI — send and receive NDI streams"
HOMEPAGE="
	https://lib.rs/crates/gst-plugin-ndi
	https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/tree/main/net/ndi
"
SRC_URI="
	https://crates.io/api/v1/crates/${PN}/${PV}/download
		-> ${P}.crate
	${CARGO_CRATE_URIS}
"

LICENSE="MPL-2.0"
# Dependent crate licenses
LICENSE+=" Apache-2.0-with-LLVM-exceptions ISC MIT Unicode-3.0"
SLOT="1.0"
KEYWORDS="~amd64 ~arm64"

DEPEND="
	dev-libs/glib
	>=media-libs/gstreamer-1.18:1.0
	>=media-libs/gst-plugins-base-1.18:${SLOT}
"
RDEPEND="
	${DEPEND}
	media-libs/libndi
"
BDEPEND="
	dev-util/cargo-c
	virtual/pkgconfig
"

QA_FLAGS_IGNORED="usr/lib.*/gstreamer-1.0/libgstndi.so"

src_configure() {
	CARGO_ARGS=(
		--library-type=cdylib
		--prefix="${EPREFIX}"/usr
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--target="$(rust_abi)"
		$(usev !debug '--release')
	)

	cargo_src_configure
}

src_compile() {
	cargo cbuild "${CARGO_ARGS[@]}" || die
}

src_test() {
	# Plugin tests need a live NDI source on the LAN; skip.
	:
}

src_install() {
	cargo cinstall "${CARGO_ARGS[@]}" --destdir="${D}" || die
}

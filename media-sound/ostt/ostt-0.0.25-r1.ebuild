# Copyright 2026 Craig Miller
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ahash@0.8.12
	aho-corasick@1.1.4
	allocator-api2@0.2.21
	alsa-sys@0.3.1
	alsa@0.9.1
	android_system_properties@0.1.5
	anstream@0.6.21
	anstyle-parse@0.2.7
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.13
	anyhow@1.0.100
	atomic-waker@1.1.2
	autocfg@1.5.0
	base64@0.22.1
	bindgen@0.72.1
	bitflags@1.3.2
	bitflags@2.10.0
	block-buffer@0.10.4
	block2@0.6.2
	bumpalo@3.19.0
	bytes@1.10.1
	cassowary@0.3.0
	castaway@0.2.4
	cc@1.2.45
	cesu8@1.1.0
	cexpr@0.6.0
	cfg-if@1.0.4
	cfg_aliases@0.2.1
	chrono@0.4.42
	clang-sys@1.8.1
	clap@4.5.54
	clap_builder@4.5.54
	clap_complete@4.5.64
	clap_derive@4.5.49
	clap_lex@0.7.6
	cliclack@0.3.6
	cmake@0.1.54
	colorchoice@1.0.4
	combine@4.6.7
	compact_str@0.8.1
	console@0.15.11
	core-foundation-sys@0.8.7
	core-foundation@0.9.4
	coreaudio-rs@0.13.0
	cpal@0.16.0
	cpufeatures@0.2.17
	crossbeam-channel@0.5.15
	crossbeam-utils@0.8.21
	crossterm@0.28.1
	crossterm_winapi@0.9.1
	crypto-common@0.1.7
	ctrlc@3.5.1
	darling@0.20.11
	darling_core@0.20.11
	darling_macro@0.20.11
	dasp_sample@0.11.0
	deranged@0.5.5
	digest@0.10.7
	dirs-sys@0.5.0
	dirs@6.0.0
	dispatch2@0.3.0
	displaydoc@0.2.5
	either@1.15.0
	encode_unicode@1.0.0
	encoding_rs@0.8.35
	equivalent@1.0.2
	errno@0.3.14
	fallible-iterator@0.3.0
	fallible-streaming-iterator@0.1.9
	fastrand@2.3.0
	find-msvc-tools@0.1.4
	fnv@1.0.7
	foldhash@0.1.5
	foreign-types-shared@0.1.1
	foreign-types@0.3.2
	form_urlencoded@1.2.2
	fs_extra@1.3.0
	futures-channel@0.3.31
	futures-core@0.3.31
	futures-io@0.3.32
	futures-macro@0.3.31
	futures-sink@0.3.31
	futures-task@0.3.31
	futures-util@0.3.31
	generic-array@0.14.7
	getrandom@0.2.16
	getrandom@0.3.4
	glob@0.3.3
	h2@0.4.12
	hashbrown@0.14.5
	hashbrown@0.15.5
	hashbrown@0.16.1
	hashlink@0.9.1
	heck@0.5.0
	hound@3.5.1
	http-body-util@0.1.3
	http-body@1.0.1
	http@1.3.1
	httparse@1.10.1
	hyper-rustls@0.27.7
	hyper-tls@0.6.0
	hyper-util@0.1.17
	hyper@1.8.0
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.64
	icu_collections@2.1.1
	icu_locale_core@2.1.1
	icu_normalizer@2.1.1
	icu_normalizer_data@2.1.1
	icu_properties@2.1.1
	icu_properties_data@2.1.1
	icu_provider@2.1.1
	ident_case@1.0.1
	idna@1.1.0
	idna_adapter@1.2.1
	indexmap@2.12.0
	indicatif@0.17.11
	indoc@2.0.7
	instability@0.3.9
	ipnet@2.11.0
	iri-string@0.7.9
	is_terminal_polyfill@1.70.2
	itertools@0.13.0
	itoa@1.0.15
	jni-sys@0.3.0
	jni@0.21.1
	js-sys@0.3.82
	lazy_static@1.5.0
	libc@0.2.177
	libloading@0.8.9
	libredox@0.1.10
	libsqlite3-sys@0.28.0
	linux-raw-sys@0.11.0
	linux-raw-sys@0.4.15
	litemap@0.8.1
	lock_api@0.4.14
	log@0.4.28
	lru@0.12.5
	mach2@0.4.3
	matchers@0.2.0
	memchr@2.7.6
	mime@0.3.17
	mime_guess@2.0.5
	minimal-lexical@0.2.1
	mio@1.1.0
	native-tls@0.2.14
	ndk-context@0.1.1
	ndk-sys@0.6.0+11769913
	ndk@0.9.0
	nix@0.30.1
	nom@7.1.3
	nu-ansi-term@0.50.3
	num-complex@0.4.6
	num-conv@0.1.0
	num-derive@0.4.2
	num-integer@0.1.46
	num-traits@0.2.19
	num_enum@0.7.5
	num_enum_derive@0.7.5
	number_prefix@0.4.0
	objc2-audio-toolbox@0.3.2
	objc2-core-audio-types@0.3.2
	objc2-core-audio@0.3.2
	objc2-core-foundation@0.3.2
	objc2-encode@4.1.0
	objc2-foundation@0.3.2
	objc2@0.6.3
	once_cell@1.21.3
	once_cell_polyfill@1.70.2
	openssl-macros@0.1.1
	openssl-probe@0.1.6
	openssl-sys@0.9.111
	openssl@0.10.75
	option-ext@0.2.0
	parking_lot@0.12.5
	parking_lot_core@0.9.12
	paste@1.0.15
	percent-encoding@2.3.2
	pin-project-lite@0.2.16
	pin-utils@0.1.0
	pkg-config@0.3.32
	portable-atomic@1.11.1
	potential_utf@0.1.4
	powerfmt@0.2.0
	prettyplease@0.2.37
	primal-check@0.3.4
	proc-macro-crate@3.4.0
	proc-macro2@1.0.103
	quote@1.0.42
	r-efi@5.3.0
	ratatui@0.29.0
	redox_syscall@0.5.18
	redox_users@0.5.2
	regex-automata@0.4.13
	regex-syntax@0.8.8
	regex@1.12.3
	reqwest@0.12.24
	ring@0.17.14
	rusqlite@0.31.0
	rustc-hash@2.1.2
	rustfft@6.4.1
	rustix@0.38.44
	rustix@1.1.2
	rustls-pki-types@1.13.0
	rustls-webpki@0.103.8
	rustls@0.23.35
	rustversion@1.0.22
	ryu@1.0.20
	same-file@1.0.6
	schannel@0.1.28
	scopeguard@1.2.0
	security-framework-sys@2.15.0
	security-framework@2.11.1
	semver@1.0.28
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.145
	serde_spanned@0.6.9
	serde_urlencoded@0.7.1
	sha2@0.10.9
	sharded-slab@0.1.7
	shlex@1.3.0
	signal-hook-mio@0.2.5
	signal-hook-registry@1.4.6
	signal-hook@0.3.18
	slab@0.4.11
	smallvec@1.15.1
	smawk@0.3.2
	socket2@0.6.1
	stable_deref_trait@1.2.1
	static_assertions@1.1.0
	strength_reduce@0.2.4
	strsim@0.11.1
	strum@0.26.3
	strum_macros@0.26.4
	subtle@2.6.1
	syn@2.0.110
	sync_wrapper@1.0.2
	synstructure@0.13.2
	system-configuration-sys@0.6.0
	system-configuration@0.6.1
	tempfile@3.23.0
	textwrap@0.16.2
	thiserror-impl@1.0.69
	thiserror-impl@2.0.17
	thiserror@1.0.69
	thiserror@2.0.17
	thread_local@1.1.9
	time-core@0.1.6
	time-macros@0.2.24
	time@0.3.44
	tinystr@0.8.2
	tokio-macros@2.6.0
	tokio-native-tls@0.3.1
	tokio-rustls@0.26.4
	tokio-util@0.7.17
	tokio@1.48.0
	toml@0.8.23
	toml_datetime@0.6.11
	toml_datetime@0.7.3
	toml_edit@0.22.27
	toml_edit@0.23.7
	toml_parser@1.0.4
	toml_write@0.1.2
	tower-http@0.6.6
	tower-layer@0.3.3
	tower-service@0.3.3
	tower@0.5.2
	tracing-appender@0.2.3
	tracing-attributes@0.1.30
	tracing-core@0.1.34
	tracing-log@0.2.0
	tracing-subscriber@0.3.20
	tracing@0.1.41
	transpose@0.2.3
	try-lock@0.2.5
	tui-input@0.14.0
	typenum@1.20.0
	unicase@2.8.1
	unicode-ident@1.0.22
	unicode-linebreak@0.1.5
	unicode-segmentation@1.12.0
	unicode-truncate@1.1.0
	unicode-width@0.1.14
	unicode-width@0.2.0
	untrusted@0.9.0
	url@2.5.7
	urlencoding@2.1.3
	utf8_iter@1.0.4
	utf8parse@0.2.2
	valuable@0.1.1
	vcpkg@0.2.15
	version_check@0.9.5
	walkdir@2.5.0
	want@0.3.1
	wasi@0.11.1+wasi-snapshot-preview1
	wasip2@1.0.1+wasi-0.2.4
	wasm-bindgen-futures@0.4.55
	wasm-bindgen-macro-support@0.2.105
	wasm-bindgen-macro@0.2.105
	wasm-bindgen-shared@0.2.105
	wasm-bindgen@0.2.105
	wasm-streams@0.4.2
	web-sys@0.3.82
	web-time@1.1.0
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.11
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.54.0
	windows-core@0.62.2
	windows-implement@0.60.2
	windows-interface@0.59.3
	windows-link@0.1.3
	windows-link@0.2.1
	windows-registry@0.5.3
	windows-result@0.1.2
	windows-result@0.3.4
	windows-result@0.4.1
	windows-strings@0.4.2
	windows-strings@0.5.1
	windows-sys@0.45.0
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-sys@0.60.2
	windows-sys@0.61.2
	windows-targets@0.42.2
	windows-targets@0.52.6
	windows-targets@0.53.5
	windows@0.54.0
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_gnullvm@0.53.1
	windows_aarch64_msvc@0.42.2
	windows_aarch64_msvc@0.52.6
	windows_aarch64_msvc@0.53.1
	windows_i686_gnu@0.42.2
	windows_i686_gnu@0.52.6
	windows_i686_gnu@0.53.1
	windows_i686_gnullvm@0.52.6
	windows_i686_gnullvm@0.53.1
	windows_i686_msvc@0.42.2
	windows_i686_msvc@0.52.6
	windows_i686_msvc@0.53.1
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnu@0.53.1
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_gnullvm@0.53.1
	windows_x86_64_msvc@0.42.2
	windows_x86_64_msvc@0.52.6
	windows_x86_64_msvc@0.53.1
	winnow@0.7.13
	wit-bindgen@0.46.0
	writeable@0.6.2
	yoke-derive@0.8.1
	yoke@0.8.1
	zerocopy-derive@0.8.31
	zerocopy@0.8.31
	zerofrom-derive@0.1.6
	zerofrom@0.1.6
	zeroize@1.8.2
	zeroize_derive@1.4.2
	zerotrie@0.2.3
	zerovec-derive@0.11.2
	zerovec@0.11.5
"

declare -A GIT_CRATES=(
	[whisper-rs-sys]='https://github.com/kristoferlund/whisper-rs;68277948f4184dee7a0409f27b2afadb4c4805ba;whisper-rs-%commit%/sys'
	[whisper-rs]='https://github.com/kristoferlund/whisper-rs;68277948f4184dee7a0409f27b2afadb4c4805ba;whisper-rs-%commit%'
)

inherit cargo shell-completion

OSTT_COMMIT="0cd75359bbffde2be5e034bd73019f70f0216792"
WHISPER_CPP_COMMIT="2eeeba56e9edd762b4b38467bab96c2517163158"

PATCHES=(
	"${FILESDIR}/${P}-auto-stop-silence.patch"
)

DESCRIPTION="Terminal-native speech-to-text recorder and transcription tool"
HOMEPAGE="https://github.com/kristoferlund/ostt https://ostt.ai"
SRC_URI="
	https://github.com/kristoferlund/${PN}/archive/${OSTT_COMMIT}.tar.gz -> ${P}.tar.gz
	https://github.com/ggerganov/whisper.cpp/archive/${WHISPER_CPP_COMMIT}.tar.gz
		-> whisper.cpp-${WHISPER_CPP_COMMIT}.tar.gz
	${CARGO_CRATE_URIS}
"
S="${WORKDIR}/${PN}-${OSTT_COMMIT}"

LICENSE="MIT"
# Crate licenses include MIT, Apache-2.0, BSD, ISC, MPL-2.0, Unicode-3.0, and Unlicense.
SLOT="0"
KEYWORDS="~amd64 ~arm64"

DEPEND="
	dev-libs/openssl:=
	media-libs/alsa-lib
"
RDEPEND="
	${DEPEND}
	gui-apps/foot
	gui-apps/wl-clipboard
	media-video/ffmpeg
"
BDEPEND="
	dev-build/cmake
	virtual/pkgconfig
"

src_prepare() {
	local whisper_rs_name="whisper-rs-68277948f4184dee7a0409f27b2afadb4c4805ba"
	local whisper_rs_dir="${WORKDIR}/${whisper_rs_name}"
	local whisper_rs_path="../${whisper_rs_name}"

	rm -rf "${whisper_rs_dir}/sys/whisper.cpp" || die
	mv "${WORKDIR}/whisper.cpp-${WHISPER_CPP_COMMIT}" \
		"${whisper_rs_dir}/sys/whisper.cpp" || die

	sed -i \
		-e "s#whisper-rs = \"0.16\"#whisper-rs = { path = \"${whisper_rs_path}\" }#" \
		-e "s#whisper-rs-sys = .*#whisper-rs-sys = { path = \"${whisper_rs_path}/sys\" }#" \
		-e '/^whisper-rs = { version = "0.16", features = \["metal"\] }$/d' \
		-e '/^\[patch.crates-io\]$/d' \
		-e '/^whisper-rs = { git = /d' \
		Cargo.toml || die
	sed -i \
		'/^source = "git+https:\/\/github.com\/kristoferlund\/whisper-rs?branch=master#68277948f4184dee7a0409f27b2afadb4c4805ba"$/d' \
		Cargo.lock || die

	default
}

src_install() {
	dobin target/release/ostt

	"${S}/target/release/ostt" completions bash > "${T}/ostt.bash" || die
	"${S}/target/release/ostt" completions zsh > "${T}/_ostt" || die
	"${S}/target/release/ostt" completions fish > "${T}/ostt.fish" || die
	newbashcomp "${T}/ostt.bash" ostt
	dozshcomp "${T}/_ostt"
	dofishcomp "${T}/ostt.fish"

	einstalldocs
}

pkg_postinst() {
	elog ""
	elog "OSTT stores user config in ~/.config/ostt/ostt.toml."
	elog "Run 'ostt auth' for cloud providers or 'ostt model' for local Whisper models."
	elog "For a popup recorder, bind a desktop shortcut to: ostt launch -c"
	elog ""
}

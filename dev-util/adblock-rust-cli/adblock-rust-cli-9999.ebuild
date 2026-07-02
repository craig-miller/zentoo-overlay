# Copyright 2026 Craig Miller
# Distributed under the terms of the MIT License

EAPI=8

RUST_MIN_VER="1.88.0"

CRATES="
	adblock@0.12.5
	addr@0.15.6
	aho-corasick@1.1.4
	arrayvec@0.7.7
	base64@0.22.1
	bitflags@2.13.0
	byteorder@1.5.0
	cssparser-macros@0.6.1
	cssparser@0.34.0
	derive_more@0.99.20
	displaydoc@0.2.6
	dtoa-short@0.3.5
	dtoa@1.0.11
	either@1.16.0
	flatbuffers@25.12.19
	form_urlencoded@1.2.2
	fxhash@0.2.1
	icu_collections@2.2.0
	icu_locale_core@2.2.0
	icu_normalizer@2.2.0
	icu_normalizer_data@2.2.0
	icu_properties@2.2.0
	icu_properties_data@2.2.0
	icu_provider@2.2.0
	idna@1.1.0
	idna_adapter@1.2.2
	itertools@0.13.0
	itoa@1.0.18
	litemap@0.8.2
	log@0.4.33
	memchr@2.8.2
	new_debug_unreachable@1.0.6
	percent-encoding@2.3.2
	phf@0.11.3
	phf_codegen@0.11.3
	phf_generator@0.11.3
	phf_macros@0.11.3
	phf_shared@0.11.3
	potential_utf@0.1.5
	precomputed-hash@0.1.1
	proc-macro2@1.0.106
	psl-types@2.0.11
	psl@2.1.215
	quote@1.0.46
	rand@0.8.6
	rand_core@0.6.4
	regex-automata@0.4.14
	regex-syntax@0.8.11
	regex@1.12.4
	rustc-hash@1.1.0
	rustc_version@0.4.1
	seahash@4.1.0
	selectors@0.26.0
	semver@1.0.28
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.150
	servo_arc@0.4.3
	siphasher@1.0.3
	smallvec@1.15.2
	stable_deref_trait@1.2.1
	syn@2.0.118
	synstructure@0.13.2
	thiserror-impl@1.0.69
	thiserror@1.0.69
	tinystr@0.8.3
	unicode-ident@1.0.24
	url@2.5.8
	utf8_iter@1.0.4
	writeable@0.6.3
	yoke-derive@0.8.2
	yoke@0.8.3
	zerofrom-derive@0.1.7
	zerofrom@0.1.8
	zerotrie@0.2.4
	zerovec-derive@0.11.3
	zerovec@0.11.6
	zmij@1.0.21
"

inherit cargo git-r3

DESCRIPTION="Convert EasyList/ABP filter lists to Apple WKContentRuleList JSON"
HOMEPAGE="https://github.com/craig-miller/adblock-rust-cli"

EGIT_REPO_URI="https://github.com/craig-miller/adblock-rust-cli.git"

SRC_URI="${CARGO_CRATE_URIS}"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0 MPL-2.0 Unicode-3.0"
SLOT="0"
KEYWORDS=""

QA_FLAGS_IGNORED="usr/bin/adblock-rust-cli"

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

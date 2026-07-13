# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Static, fast, dependency-free search for static websites (Nix-cache repackaged)"
HOMEPAGE="https://pagefind.app/"

# Upstream's official musl prebuilts embed jemalloc compiled with LG_PAGE=12 (4K)
# and abort on any allocation on Asahi/RPi5's 16K page kernels. A source build
# requires Node.js + npm + wasm-pack for the pagefind_web / pagefind_ui / playground
# WASM assets which upstream's Cargo build reads via include_bytes!(); we don't want
# that toolchain on zentoo. This ebuild repackages the Nixpkgs aarch64-linux build
# (pagefind-extended-1.5.2 from cache.nixos.org, /nix/store/664z5xgcm...) after
# extracting bin/pagefind from the .nar archive and re-hosting it as a GitHub Release
# asset. patchelf switches the loader + drops the /nix/store/ RPATH so the binary
# links against zentoo's system glibc + libgcc_s at runtime.
# Upstream tracking: https://github.com/Pagefind/pagefind/issues/1147
# Drop this ebuild + revert Ch.34 caveat once #1147 lands upstream.

SRC_URI="arm64? ( https://github.com/craig-miller/zentoo-overlay/releases/download/${PN}-${PV}/pagefind-aarch64-linux )"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~arm64"

RDEPEND="
	>=sys-libs/glibc-2.42
	sys-devel/gcc
"
BDEPEND="dev-util/patchelf"

RESTRICT="mirror strip"
QA_PREBUILT="usr/bin/pagefind"

src_unpack() {
	cp "${DISTDIR}/pagefind-aarch64-linux" "${S}/pagefind" || die
	chmod +x "${S}/pagefind" || die
}

src_prepare() {
	default
	patchelf --set-interpreter /usr/lib64/ld-linux-aarch64.so.1 pagefind || die
	patchelf --remove-rpath pagefind || die
}

src_install() {
	dobin pagefind
}

# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Swift toolchain version manager (source build, Gentoo-patched)"
HOMEPAGE="https://www.swift.org/install/linux/ https://github.com/swiftlang/swiftly"
SRC_URI="https://github.com/swiftlang/swiftly/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~arm64"

# SwiftPM resolves ~11 package deps from the network during the build, which
# Gentoo's build sandbox forbids. Vendoring is future work; allow network.
RESTRICT="network-sandbox mirror"

# Built with --static-swift-stdlib, so the Swift runtime is embedded: no
# dev-lang/swift runtime coupling. Only libarchive + libz are dynamic.
RDEPEND="
	app-arch/libarchive
	sys-libs/zlib
	!!dev-util/swiftly-bin
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/swift
	virtual/pkgconfig
"

# Gentoo integration: native platform detection + generic system-toolchain
# auto-detection (the Linux analog of macOS's .xcode handling) so swiftly uses
# the active dev-lang/swift instead of downloading, and never clobbers it.
PATCHES=( "${FILESDIR}/${P}-gentoo-system-toolchain.patch" )

src_compile() {
	# Foundation's NSHomeDirectory() reads the passwd DB (getpwuid), not $HOME
	# (which portage leaves unset), so SwiftPM's ~/.swiftpm always lands in the
	# build user's passwd home. Permit writes there; --*-path keeps the bulk in ${T}.
	addwrite "$(getent passwd "$(id -u)" | cut -d: -f6)/"
	swift build -c release --product swiftly --static-swift-stdlib \
		--cache-path "${T}"/spm-cache \
		--config-path "${T}"/spm-config \
		--security-path "${T}"/spm-security \
		|| die "swift build failed"
}

src_install() {
	newbin .build/release/swiftly swiftly
	dodoc README.md
}

pkg_postinst() {
	elog "swiftly auto-detects the active system Swift (dev-lang/swift) and exposes"
	elog "it as a toolchain -- no linking, symlinks, or config needed."
	elog "Initialise your account with:"
	elog "    swiftly init --skip-install --assume-yes --no-modify-profile"
	elog "(the 'swiftly-init' fish abbr does this). Then 'swiftly run +<ver> ...'"
	elog "resolves to the system toolchain; install/uninstall will not touch it."
}

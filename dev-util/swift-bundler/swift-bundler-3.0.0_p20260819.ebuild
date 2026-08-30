# Copyright 2026 Craig Miller
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Upstream recommends installing from main while 3.0-breaking-change work is in
# flight and tagged releases are stale. Pin a known-good main commit instead of
# using a live ebuild so Zentoo installs remain reproducible.
MY_COMMIT="b4a54317d67385f8aa23d6e69172c7cf2ec81b45"

DESCRIPTION="Tool for creating cross-platform Swift app bundles"
HOMEPAGE="https://github.com/moreSwift/swift-bundler https://swiftbundler.dev"
SRC_URI="https://github.com/moreSwift/swift-bundler/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~arm64"

# SwiftPM resolves package dependencies from the network during the build, which
# Gentoo's build sandbox forbids. Vendoring Package.resolved is future work.
RESTRICT="network-sandbox mirror"

RDEPEND="
	dev-lang/swift
	dev-util/patchelf
"
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}"

src_compile() {
	# Foundation's NSHomeDirectory() reads the passwd DB (getpwuid), not $HOME
	# (which portage leaves unset), so SwiftPM's ~/.swiftpm always lands in the
	# build user's passwd home. Permit writes there; --*-path keeps the bulk in ${T}.
	local build_home
	build_home="$(getent passwd "$(id -u)" | cut -d: -f6)"
	addwrite "${build_home}/"

	SBUN_NO_SCHEMA_GEN=1 \
	swift build -c release --product swift-bundler \
		--cache-path "${T}"/spm-cache \
		--config-path "${T}"/spm-config \
		--security-path "${T}"/spm-security \
		|| die "swift build failed"
}

src_install() {
	dobin .build/release/swift-bundler
	dodoc README.md LICENSE
}

pkg_postinst() {
	elog "Swift Bundler is installed as /usr/bin/swift-bundler."
	elog "Use: swift-bundler --version"
	elog "Note: this Zentoo/Swift install does not currently dispatch it as: swift bundler"
	elog "Optional output formats require extra tools not pulled by default:"
	elog "  linuxRPM: app-arch/rpm"
	elog "  linuxAppImage: appimagetool"
}

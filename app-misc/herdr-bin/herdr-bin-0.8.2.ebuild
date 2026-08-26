# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

DESCRIPTION="Terminal workspace multiplexer with agent-state awareness for AI coding agents"
HOMEPAGE="https://herdr.dev/ https://github.com/herdrdev/herdr/"

SRC_URI="
	amd64? ( https://github.com/herdrdev/herdr/releases/download/v${PV}/herdr-linux-x86_64 -> ${P}-amd64 )
	arm64? ( https://github.com/herdrdev/herdr/releases/download/v${PV}/herdr-linux-aarch64 -> ${P}-arm64 )
"

S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="strip test"

QA_PREBUILT="usr/bin/herdr"

src_unpack() {
	:
}

src_install() {
	if use amd64; then
		newbin "${DISTDIR}/${P}-amd64" herdr
	elif use arm64; then
		newbin "${DISTDIR}/${P}-arm64" herdr
	else
		die "Unsupported architecture"
	fi

	domenu "${FILESDIR}"/herdr.desktop
}

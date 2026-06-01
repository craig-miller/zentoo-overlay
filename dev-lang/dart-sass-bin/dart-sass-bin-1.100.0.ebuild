# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The reference implementation of Sass, AOT-compiled to a native binary"
HOMEPAGE="https://sass-lang.com/dart-sass https://github.com/sass/dart-sass"

SRC_URI="
	amd64?  ( https://github.com/sass/dart-sass/releases/download/${PV}/dart-sass-${PV}-linux-x64.tar.gz     -> ${P}-linux-x64.tar.gz )
	arm?    ( https://github.com/sass/dart-sass/releases/download/${PV}/dart-sass-${PV}-linux-arm.tar.gz     -> ${P}-linux-arm.tar.gz )
	arm64?  ( https://github.com/sass/dart-sass/releases/download/${PV}/dart-sass-${PV}-linux-arm64.tar.gz   -> ${P}-linux-arm64.tar.gz )
	riscv?  ( https://github.com/sass/dart-sass/releases/download/${PV}/dart-sass-${PV}-linux-riscv64.tar.gz -> ${P}-linux-riscv64.tar.gz )
"

S="${WORKDIR}/dart-sass"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm ~arm64 ~riscv"

RESTRICT="bindist mirror strip"

# Prebuilt Dart binary links against glibc.
RDEPEND="elibc_glibc? ( sys-libs/glibc )"

QA_PREBUILT="opt/dart-sass/src/dart opt/dart-sass/src/sass.snapshot"

src_install() {
	exeinto /opt/dart-sass
	doexe sass

	exeinto /opt/dart-sass/src
	doexe src/dart

	insinto /opt/dart-sass/src
	doins src/sass.snapshot

	dosym ../../opt/dart-sass/sass /usr/bin/sass

	dodoc src/LICENSE
}

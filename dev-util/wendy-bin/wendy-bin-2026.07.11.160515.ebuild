# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Upstream tags releases as YYYY.MM.DD-HHMMSS. Portage can't have a bare '-'
# in PV, so PV uses a '.' there and we reconstruct the tag/filename below.
MY_TAG="${PV%.*}-${PV##*.}"

DESCRIPTION="Wendy CLI - build, deploy and debug apps on WendyOS edge devices"
HOMEPAGE="https://wendy.dev https://github.com/wendylabsinc/WendyOS"

SRC_URI="
	amd64? ( https://github.com/wendylabsinc/WendyOS/releases/download/${MY_TAG}/wendy-cli-linux-amd64-${MY_TAG}.tar.gz )
	arm64? ( https://github.com/wendylabsinc/WendyOS/releases/download/${MY_TAG}/wendy-cli-linux-arm64-${MY_TAG}.tar.gz )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# Prebuilt, statically-linked upstream binary: don't strip, skip QA scans, no deps.
RESTRICT="strip"
QA_PREBUILT="*"
RDEPEND=""
BDEPEND=""

# Each arch tarball unpacks to its own top-level dir under ${WORKDIR}.
S="${WORKDIR}"

src_install() {
	local mydir
	if use amd64; then
		mydir="wendy-cli-linux-amd64"
	else
		mydir="wendy-cli-linux-arm64"
	fi

	dobin "${mydir}/wendy"
	dodoc "${mydir}/NOTICE"
}

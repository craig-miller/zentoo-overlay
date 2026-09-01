# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="Rule-based sentence boundary disambiguation"
HOMEPAGE="
	https://github.com/nipunsadvilkar/pySBD
	https://pypi.org/project/pysbd/
"
SRC_URI="https://github.com/nipunsadvilkar/pySBD/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/pySBD-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_install_all() {
	distutils-r1_python_install_all
	find "${D}" -path '*/site-packages/benchmarks' -type d -prune -exec rm -r {} + || die
}

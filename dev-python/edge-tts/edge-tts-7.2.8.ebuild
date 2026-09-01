# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
inherit pypi distutils-r1
MY_PN="edge_tts"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Python module and CLI for Microsoft Edge online text-to-speech service"
HOMEPAGE="https://github.com/rany2/edge-tts https://pypi.org/project/edge-tts/"
SRC_URI="$(pypi_sdist_url --no-normalize ${MY_PN} ${PV})"
S="${WORKDIR}/${MY_P}"
LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RDEPEND="dev-python/aiohttp[${PYTHON_USEDEP}] dev-python/certifi[${PYTHON_USEDEP}] dev-python/tabulate[${PYTHON_USEDEP}] dev-python/typing-extensions[${PYTHON_USEDEP}]"
EPYTEST_PLUGINS=()
distutils_enable_tests pytest

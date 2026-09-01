# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit pypi distutils-r1

DESCRIPTION="Open-source on-device wake word detection SDK and training pipeline"
HOMEPAGE="
	https://github.com/GeeIHadAGoodTime/ViolaWake
	https://pypi.org/project/violawake/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/openwakeword[${PYTHON_USEDEP}]
	dev-python/pysbd[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	sci-libs/onnxruntime[python,${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()

distutils_enable_tests pytest

python_test() {
	# The PyPI sdist intentionally excludes tests.
	:
}

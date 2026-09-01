# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
inherit pypi distutils-r1
DESCRIPTION="ONNX in-memory representation"
HOMEPAGE="https://github.com/onnx/ir-py https://pypi.org/project/onnx-ir/"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RDEPEND="dev-python/numpy[${PYTHON_USEDEP}] dev-python/typing-extensions[${PYTHON_USEDEP}] sci-ml/onnx[${PYTHON_USEDEP}]"
EPYTEST_PLUGINS=()
distutils_enable_tests pytest

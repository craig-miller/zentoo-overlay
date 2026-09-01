# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
inherit pypi distutils-r1
DESCRIPTION="Author ONNX functions and models using Python"
HOMEPAGE="https://github.com/microsoft/onnxscript https://pypi.org/project/onnxscript/"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RDEPEND="dev-python/ml-dtypes[${PYTHON_USEDEP}] dev-python/numpy[${PYTHON_USEDEP}] dev-python/onnx-ir[${PYTHON_USEDEP}] dev-python/packaging[${PYTHON_USEDEP}] dev-python/typing-extensions[${PYTHON_USEDEP}] sci-ml/onnx[${PYTHON_USEDEP}]"
EPYTEST_PLUGINS=()
distutils_enable_tests pytest

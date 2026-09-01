# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit pypi distutils-r1

OWW_MODELS_RELEASE="0.5.1"

DESCRIPTION="Open-source audio wake word detection framework"
HOMEPAGE="
	https://github.com/dscripka/openWakeWord
	https://pypi.org/project/openwakeword/
"
SRC_URI="
	$(pypi_sdist_url --no-normalize)
	https://github.com/dscripka/openWakeWord/releases/download/v${OWW_MODELS_RELEASE}/melspectrogram.onnx
		-> ${P}-melspectrogram.onnx
	https://github.com/dscripka/openWakeWord/releases/download/v${OWW_MODELS_RELEASE}/embedding_model.onnx
		-> ${P}-embedding_model.onnx
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/scikit-learn[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	sci-libs/onnxruntime[python,${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()

distutils_enable_tests pytest

src_prepare() {
	# Zentoo's wake runtime uses the ONNX backend. Upstream declares
	# tflite-runtime as an unconditional Linux dependency, but tflite-runtime has
	# poor Python/platform coverage and is not required for ONNX inference.
	sed -i "/tflite-runtime/d" setup.py || die
	distutils-r1_src_prepare
}

python_install_all() {
	distutils-r1_python_install_all
	python_foreach_impl python_install_oww_models
}

python_install_oww_models() {
	local site_dir
	site_dir="$(python_get_sitedir)"
	insinto "${site_dir}/openwakeword/resources/models"
	newins "${DISTDIR}/${P}-melspectrogram.onnx" melspectrogram.onnx
	newins "${DISTDIR}/${P}-embedding_model.onnx" embedding_model.onnx
}

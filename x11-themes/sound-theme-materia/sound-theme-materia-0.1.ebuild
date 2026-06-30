# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="A freedesktop sound theme using Google's Material sound resources"
HOMEPAGE="https://github.com/nana-4/materia-sound-theme"
SRC_URI="https://github.com/nana-4/materia-sound-theme/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~arm64"

S="${WORKDIR}/materia-sound-theme-${PV}"

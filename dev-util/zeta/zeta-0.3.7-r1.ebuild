# Copyright 2026 Craig Miller
# Distributed under the terms of the MIT License

EAPI=8

inherit go-module

# zeta does not commit its graph-UI JS or the Typst tree-sitter grammar; the
# upstream Nix flake fetches both at build time. Pin the same revisions here and
# vendor them in src_prepare where //go:embed and parser.go's cgo -I expect them.
GRAMMAR_COMMIT="46cf4ded12ee974a70bf8457263b67ad7ee0379d"
FORCE_GRAPH_PV="1.49.5"

DESCRIPTION="Typst-aware note-graph language server (Zettelkasten navigation)"
HOMEPAGE="https://github.com/lentilus/zeta"
DEPS_URI="https://github.com/craig-miller/zentoo-overlay/releases/download"
GRAMMAR_URI="https://github.com/uben0/tree-sitter-typst/archive"
FG_URI="https://cdn.jsdelivr.net/npm/force-graph@${FORCE_GRAPH_PV}/dist"
SRC_URI="
	https://github.com/lentilus/zeta/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${DEPS_URI}/${P}/${P}-deps.tar.xz
	${GRAMMAR_URI}/${GRAMMAR_COMMIT}.tar.gz -> tree-sitter-typst-${GRAMMAR_COMMIT:0:12}.tar.gz
	${FG_URI}/force-graph.min.js -> force-graph-${FORCE_GRAPH_PV}.min.js
"

# Upstream ships no license file; its own code is treated as all-rights-reserved.
# The remaining tokens cover assets compiled/embedded into the binary: the Go
# deps (gorilla/websocket BSD-2, smacker/go-tree-sitter MIT, tliron/glsp and
# commonlog Apache-2.0), the uben0/tree-sitter-typst grammar built via cgo (MIT),
# and the bundled force-graph.js graph UI (MIT).
LICENSE="all-rights-reserved Apache-2.0 BSD-2 MIT"
SLOT="0"
KEYWORDS="~arm64"

PATCHES=(
	"${FILESDIR}"/zeta-0.3.7-root-uri-nil.patch
)

src_prepare() {
	default
	mkdir -p external/_vendor || die
	cp "${DISTDIR}/force-graph-${FORCE_GRAPH_PV}.min.js" \
		external/_vendor/force-graph.js || die
	mv "${WORKDIR}/tree-sitter-typst-${GRAMMAR_COMMIT}" \
		external/_vendor/tree-sitter-typst || die
}

src_compile() {
	ego build -ldflags "-X main.Version=v${PV}" -o zeta .
}

src_install() {
	dobin zeta
}

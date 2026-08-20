# Copyright 2026 Craig Miller
# Distributed under the terms of the MIT License

EAPI=8

DESCRIPTION="Research/PKM tools: sioyek->typst highlights + card-list daemon + setup"
HOMEPAGE="https://github.com/craig-miller/zentoo-overlay"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~arm64"

RDEPEND="
	app-text/sioyek
	dev-lang/python:*
	app-shells/bash
	app-misc/watchexec
"

src_install() {
	dobin "${FILESDIR}"/export-highlights
	dobin "${FILESDIR}"/research-cards-daemon
	dobin "${FILESDIR}"/research-setup

	insinto /etc/xdg/autostart
	doins "${FILESDIR}"/research-cards.desktop

	insinto /usr/share/zentoo-research/templates
	doins "${FILESDIR}"/templates/note.typ
	doins "${FILESDIR}"/templates/README.md
	insinto /usr/share/zentoo-research/templates/csl
	doins "${FILESDIR}"/templates/csl/taylor-and-francis-harvard-x.csl

	insinto /usr/share/zentoo-research/defaults
	doins "${FILESDIR}"/defaults/papis-config
	doins "${FILESDIR}"/defaults/papis-config.py
	doins "${FILESDIR}"/defaults/papis-notes-template.typ
}

pkg_postinst() {
	elog "Bootstrap the full research PKM setup with one command:"
	elog ""
	elog "  research-setup"
	elog ""
	elog "It's idempotent and non-destructive — safe to re-run. Handles:"
	elog "  - uv tool install for papis + papis-scihub + bib"
	elog "  - creating ~/research/ with templates + typst.toml"
	elog "  - installing default papis config into ~/.config/papis/"
	elog "  - appending the sioyek new_command + H/Z keybinds"
	elog "  - starting the research-cards-daemon (also autostarts via dex)"
	elog ""
	elog "Preview without writing anything:  research-setup --dry-run"
}

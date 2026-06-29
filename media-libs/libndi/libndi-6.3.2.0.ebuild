# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="NewTek/Vizrt NDI SDK runtime — libndi.so for IP video transport"
HOMEPAGE="https://ndi.video/for-developers/ndi-sdk/"

MY_MAJOR="${PV%%.*}"
MY_INSTALLER="Install_NDI_SDK_v${MY_MAJOR}_Linux.tar.gz"
SRC_URI="https://downloads.ndi.tv/SDK/NDI_SDK_Linux/${MY_INSTALLER} -> ${P}.tar.gz"

S="${WORKDIR}"

LICENSE="NDI-SDK"
SLOT="0/${MY_MAJOR}"
KEYWORDS="~amd64 ~arm64"
RESTRICT="fetch mirror strip"

RDEPEND="
	net-dns/avahi
"

QA_PREBUILT="opt/ndi/lib/*"

pkg_nofetch() {
	einfo
	einfo "The NDI SDK is proprietary and EULA-gated; fetch is disabled."
	einfo
	einfo "1. Accept the SDK License Agreement at:"
	einfo "     https://ndi.video/for-developers/ndi-sdk/"
	einfo
	einfo "2. Download the Linux installer (current 6.x train):"
	einfo "     https://downloads.ndi.tv/SDK/NDI_SDK_Linux/${MY_INSTALLER}"
	einfo
	einfo "3. Save the file into your distfiles cache, renamed to ${P}.tar.gz:"
	einfo "     ${DISTDIR}/${P}.tar.gz"
	einfo
	einfo "4. Re-run emerge."
	einfo
}

src_unpack() {
	unpack "${P}.tar.gz"

	local installer="Install_NDI_SDK_v${MY_MAJOR}_Linux.sh"
	[[ -f "${installer}" ]] || die "Expected installer ${installer} not present after unpack"

	local begin
	begin=$(awk '/^__NDI_ARCHIVE_BEGIN__$/ { print NR + 1; exit }' "${installer}") \
		|| die "Could not locate __NDI_ARCHIVE_BEGIN__ in ${installer}"

	tail -n "+${begin}" "${installer}" | tar -xzf - \
		|| die "Failed to extract embedded NDI archive"
}

src_install() {
	local sdkdir="${S}/NDI SDK for Linux"
	local arch_dir

	# Vizrt labels the aarch64 build with a Pi4-era triple; the binary
	# itself is generic ARM aarch64 ELF, suitable for any Linux arm64 host.
	case "${ARCH}" in
		arm64) arch_dir="aarch64-rpi4-linux-gnueabi" ;;
		amd64) arch_dir="x86_64-linux-gnu" ;;
		*) die "Unsupported ARCH: ${ARCH}" ;;
	esac

	[[ -d "${sdkdir}/lib/${arch_dir}" ]] \
		|| die "Expected lib path missing: ${sdkdir}/lib/${arch_dir}"

	# Headers
	insinto /opt/ndi/include
	doins -r "${sdkdir}/include/"*

	# Library + recreate SONAME chain.
	exeinto /opt/ndi/lib
	doexe "${sdkdir}/lib/${arch_dir}/"libndi.so.*

	local libfile
	libfile=$(find "${sdkdir}/lib/${arch_dir}/" -maxdepth 1 -name 'libndi.so.*' \
		-printf '%f\n' | head -n1)
	[[ -n "${libfile}" ]] || die "No libndi.so.* found in tarball"
	dosym "${libfile}" "/opt/ndi/lib/libndi.so.${MY_MAJOR}"
	dosym "libndi.so.${MY_MAJOR}" "/opt/ndi/lib/libndi.so"

	# Vendor tools (ndi-record, ndi-directory-service, etc.)
	if [[ -d "${sdkdir}/bin/${arch_dir}" ]]; then
		exeinto /opt/ndi/bin
		doexe "${sdkdir}/bin/${arch_dir}/"*
	fi

	# Wire NDI_RUNTIME_DIR_V6 into the env globally so gst-plugin-ndi,
	# ffmpeg, and any other dlopen consumer locates libndi without
	# extra shell config.
	newenvd "${FILESDIR}/99ndi" 99ndi

	# Ship the SDK's EULA + library bundle license at /usr/share/doc.
	docinto licenses
	if [[ -f "${sdkdir}/NDI SDK License Agreement.txt" ]]; then
		newdoc "${sdkdir}/NDI SDK License Agreement.txt" NDI-SDK-License.txt
	fi
	if [[ -f "${sdkdir}/licenses/libndi_licenses.txt" ]]; then
		newdoc "${sdkdir}/licenses/libndi_licenses.txt" libndi_licenses.txt
	fi

	docinto ''
	if [[ -d "${sdkdir}/documentation" ]]; then
		dodoc "${sdkdir}/documentation/"*.pdf
	fi
}

pkg_postinst() {
	elog
	elog "libndi installed under /opt/ndi/."
	elog "NDI_RUNTIME_DIR_V6=/opt/ndi/lib is wired into the global env."
	elog "Run 'env-update && source /etc/profile' (or re-login) to pick it up."
	elog
}

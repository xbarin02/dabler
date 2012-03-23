# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Embedded Linux System Development Kit specifically targeting FPGA-based System-on-Chip designs"
HOMEPAGE="http://www.petalogix.com/products/petalinux"
SRC_URI="http://www.fit.vutbr.cz/~ibarina/pub/${PN}-v${PV}-final.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64 ~x86"
IUSE=""
RESTRICT="binchecks strip"
DEPEND=""
RDEPEND="${DEPEND}"

pkg_setup() {
	if [[ "${FEATURES}" =~ "fixlafiles" ]] ; then
		die "!!! This package requires FEATURES=\"-fixlafiles\" variable. !!!"
	fi

	export PORTAGE_COMPRESS=""
}

src_install() {
	mkdir -p "${ED}"/opt
	mv ${PN}* "${ED}"/opt/${PN} || die "Failure moving directory."
}

pkg_postinst() {
	elog
	elog "To use PetaLinux you need to do the following steps as a normal user."
	elog
	elog "Change to the root directory of your PetaLinux environment..."
	elog " cd ${EROOT}opt/${PN}"
	elog
	elog "...and source one of the following shell scripts"
	elog " * if you use bash, sh, dash, etc.:"
	elog "   source settings.sh"
	elog " * if you use csh, tcsh, etc.:"
	elog "   source settings.csh"
	elog
}

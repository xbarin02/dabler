# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="UTIA ASVP (formerly EdkDSP) platform and examples"
HOMEPAGE="http://zs.utia.cz/"
SRC_URI="ftp://ftp.utia.cas.cz/pub/staff/bartosr/SMECY/${PN}-s4.out -> ${P}.out"
LICENSE="UTIA"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""
RESTRICT="binchecks strip"
DEPEND="app-arch/unzip"
RDEPEND=""

src_unpack() {
	unzip -qo -P JU100230 "${DISTDIR}"/"${A}" || die "failure unpacking ${A}"
	mv ${PN}*.zip ${PN}.zip
	DISTDIR=. unpack ${PN}.zip
	rm ${PN}.zip
	mv ${PN}* ${PN}
}

src_install() {
	mkdir -p "${ED}"/opt
	mv ${PN} "${ED}/opt" || die "failure moving directory"
}

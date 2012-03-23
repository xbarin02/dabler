# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="UTIA EdkDSP Platform and examples"
HOMEPAGE="http://zs.utia.cz/"
SRC_URI="ftp://ftp.utia.cas.cz/pub/staff/bartosr/SMECY/edd21_b1012.out -> edd21.zip"
LICENSE="UTIA"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""
RESTRICT="binchecks strip"
DEPEND="app-arch/unzip"
RDEPEND=""

src_unpack() {
	unzip -qo -P JU100230 "${DISTDIR}"/"${A}" || die "failure unpacking ${A}"
	DISTDIR=. unpack ${PN}*
}

src_install() {
	mkdir -p "${ED}"/opt
	mv ${PN} "${ED}/opt" || die "failure moving directory"
}

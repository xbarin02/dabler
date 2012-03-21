# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils toolchain-funcs

PACKAGE_VERSION="2011-10-07-dev"
DESCRIPTION="A cross-platform discrete wavelet transform library"
HOMEPAGE="http://www.fit.vutbr.cz/research/view_product.php?id=211"
SRC_URI="${HOMEPAGE}&file=%2Fproduct%2F211%2F${PN}-${PACKAGE_VERSION}.zip -> ${PN}-${PACKAGE_VERSION}.zip"
LICENSE="BUT"
SLOT="0"
KEYWORDS="-* amd64"
IUSE="+doc +static-libs debug +opencv"
DEPEND="opencv? ( media-libs/opencv )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${PACKAGE_VERSION}"

src_compile() {
	emake -C src ARCH="${CHOST%%-*}" BUILD=$(usex debug debug release) || die "emake failed"
	use opencv && ( emake -C src ARCH="${CHOST%%-*}" BUILD=$(usex debug debug release) cvdwt.o || die "emake failed" )
	use doc && ( emake -C doc || die "emake failed" )
	use static-libs && ( "$(tc-getAR)" -rsc "${PN}.a" "src/${PN}.o" || die "ar failed" )
	use static-libs && use opencv && ( "$(tc-getAR)" -rsc cvdwt.a "src/cvdwt.o" || die "ar failed" )
	"$(tc-getCC)" -shared -o "${PN}.so" "src/${PN}.o" || die "cc failed"
}

src_install()
{
	install -D -m0644 src/${PN}.h ${ED}/usr/include/${PN}.h || die "install failed"
	use opencv && ( install -D -m0644 src/cvdwt.h ${ED}/usr/include/cvdwt.h || die "install failed" )
	use static-libs && ( dolib.a "${PN}.a" || die "dolib.a failed" )
	use static-libs && use opencv && ( dolib.a "cvdwt.a" || die "dolib.a failed" )
	dolib.so "${PN}.so" || die "dolib.so failed"
	use doc && ( dohtml -r doc/html/* || die "dohtml failed" )
	dodoc AUTHORS ChangeLog INSTALL README THANKS TODO VERSION || die "dodoc failed"
}

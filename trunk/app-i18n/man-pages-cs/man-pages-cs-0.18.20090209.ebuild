# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="A somewhat comprehensive collection of Linux czech man page translations"
HOMEPAGE="http://tropikhajma.sweb.cz/man-pages-cs/"
SRC_URI="http://tropikhajma.sweb.cz/${PN}/${P}.tar.lzma
	http://www.watzke.cz/mirror/${PN}/source/${P}.tar.lzma"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""
DEPEND="app-arch/xz-utils"
RDEPEND="virtual/man"

src_prepare() {
	rm -f procps/{kill,uptime}.1 man-pages/man1/{dir,du,vdir}.1
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc CONTRIB README*

	rm -f "${D}"/usr/share/man/cs/man1/{groups,su}.1 # sys-apps/shadow
}

# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit eutils flag-o-matic autotools

DESCRIPTION="Modifies ELFs to avoid runtime symbol resolutions resulting in faster load times"
HOMEPAGE="http://people.redhat.com/jakub/prelink"

#SRC_URI="mirror://gentoo/${P}.tar.bz2"
SRC_URI="http://people.redhat.com/jakub/prelink/${P}.tar.bz2"
#
# if not available rip the distfile with rpm2targz from
# http://mirrors.kernel.org/fedora/development/rawhide/source/SRPMS/prelink-[ver].src.rpm

# track http://pkgs.fedoraproject.org/gitweb/?p=prelink.git;a=summary for
# version bumps

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 -arm ~ppc ~ppc64 ~x86"
IUSE="selinux"

DEPEND=">=dev-libs/elfutils-0.100
	!dev-libs/libelf
	>=sys-libs/glibc-2.8"
RDEPEND="${DEPEND}
	>=sys-devel/binutils-2.18"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-20061201-prelink-conf.patch

	sed -i -e 's:undosyslibs.sh::' testsuite/Makefile.in #254201
	sed -i -e '/^CC=/s: : -Wl,--disable-new-dtags :' testsuite/functions.sh #100147
	# >=binutils-2.22 --no-copy-dt-needed-entries is the default
	# --copy-dt-needed-entries was renamed from --add-needed in 2.21, use the
	# former so we don't have to bump the dep
	sed -i \
		-e '/CCLINK=/s:\(CCLINK="$(CC)\):\1 -Wl,--add-needed :' \
		-e '/CXXLINK=/s:\(CXXLINK="$(CXX)\):\1 -Wl,--add-needed :' \
		testsuite/Makefile.in

	# older GCCs don't support this flag
	sed -i -e 's:-Wno-pointer-sign::' src/Makefile.in #325269
	append-cflags -Wno-pointer-sign
	strip-unsupported-flags

	epatch "${FILESDIR}"/${P}-selinux.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable selinux)
}

src_install() {
	emake DESTDIR="${D}" install || die "Install Failed"

	insinto /etc
	doins doc/prelink.conf || die

	exeinto /etc/cron.daily
	newexe "${FILESDIR}"/prelink.cron prelink
	newconfd "${FILESDIR}"/prelink.confd prelink

	dodir /var/{lib/misc,log}
	touch "${D}/var/lib/misc/prelink.full"
	touch "${D}/var/lib/misc/prelink.quick"
	touch "${D}/var/lib/misc/prelink.force"
	touch "${D}/var/log/prelink.log"

	dodoc TODO ChangeLog
}

pkg_postinst() {
	echo
	elog "You may wish to read the Gentoo Linux Prelink Guide, which can be"
	elog "found online at:"
	elog
	elog "    http://www.gentoo.org/doc/en/prelink-howto.xml"
	elog
	elog "Please edit /etc/conf.d/prelink to enable and configure prelink"
	echo
	touch "${ROOT}/var/lib/misc/prelink.force"
}

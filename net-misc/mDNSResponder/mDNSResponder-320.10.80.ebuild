# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils base toolchain-funcs flag-o-matic java-pkg-opt-2

DESCRIPTION="A component of Bonjour, Apple's initiative for zero-configuration networking."
HOMEPAGE="http://developer.apple.com/networking/bonjour/index.html"
SRC_URI="http://www.opensource.apple.com/tarballs/${PN}/${P}.tar.gz"
LICENSE="Apache-2.0 BSD"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc"

RDEPEND="!net-dns/avahi[mdnsresponder-compat]
	!sys-auth/nss-mdns
	java? ( >=virtual/jre-1.4 )"
DEPEND="java? ( >=virtual/jdk-1.4 )
	sys-devel/bison
	sys-devel/flex"

PATCHES=( "${FILESDIR}/mDNSResponder-107.6-java.patch" )

pkg_setup() {
	if use elibc_FreeBSD; then
		os=freebsd
	else
		os=linux
	fi
	java-pkg-opt-2_pkg_setup
}

src_prepare() {
	java-pkg-opt-2_src_prepare
	base_src_prepare
	#Respect CFLAGS,LDFLAGS everywhere
	sed -i "/\$(CFLAGS_DEBUG)$/s: = : & ${CFLAGS} ${LDFLAGS} :" "${S}"/mDNSPosix/Makefile || die
	sed -i "s:cc:& ${CFLAGS} ${LDFLAGS} :" "${S}"/Clients/Makefile || die
}

mdnsmake() {
	local debug jdk
	use java && jdk="JDK=$(java-config -O)"
	if use debug; then
		debug='DEBUG=1'
		sed -e 's|LIBS = -L../mDNSPosix/build/prod/ -ldns_sd|LIBS = -L../mDNSPosix/build/debug/ -ldns_sd|g' ../Clients/Makefile || die "sed failed"
	fi

	einfo "Running emake " os="${os}" CC="$(tc-getCC)" LD="$(tc-getCC) -shared" \
		${jdk} ${debug} LINKOPTS="${LDFLAGS}" \
		LOCALBASE="/usr" JAVACFLAGS="${JAVACFLAGS}" "$@"
	emake -j1 os="${os}" CC="$(tc-getCC)" LD="$(tc-getCC) -shared" \
		${jdk} ${debug} LINKOPTS="${LDFLAGS}" \
		LOCALBASE="/usr" JAVACFLAGS="${JAVACFLAGS}" "$@"
}

src_compile() {
	cd "${S}"/mDNSPosix
	mdnsmake || die "make failed"

	if use java; then
		mdnsmake Java || die "make mDNSPosix java failed"
		if use doc ; then
			mdnsmake JavaDoc || die "make mDNSPosix java doc failed"
		fi
	fi
}

src_install() {
	cd "${S}"/mDNSPosix

	dodir /usr/sbin
	dodir /usr/lib
	dodir /usr/include
	dodir /lib
	dodir /etc
	dodir /usr/share/man/man5
	dodir /usr/share/man/man8

	local debug
	local objdir="prod"
	if use debug; then
		debug="DEBUG=1"
		objdir=debug
	fi

	dosbin "${S}"/mDNSPosix/build/${objdir}/dnsextd
	dosbin "${S}"/mDNSPosix/build/${objdir}/mDNSResponderPosix
	dosbin "${S}"/mDNSPosix/build/${objdir}/mDNSNetMonitor
	dosbin "${S}"/mDNSPosix/build/${objdir}/mdnsd

	dobin "${S}"/Clients/build/dns-sd
	dobin "${S}"/mDNSPosix/build/${objdir}/mDNSProxyResponderPosix
	dobin "${S}"/mDNSPosix/build/${objdir}/mDNSIdentify
	dobin "${S}"/mDNSPosix/build/${objdir}/mDNSClientPosix

	dolib "${S}"/mDNSPosix/build/${objdir}/libdns_sd.so
	dolib "${S}"/mDNSPosix/build/${objdir}/libnss_mdns-0.2.so
	dosym libdns_sd.so /usr/$(get_libdir)/libdns_sd.so.1
	dosym libnss_mdns-0.2.so /usr/$(get_libdir)/libnss_mdns.so.2

	if use java ; then
		dolib "${S}"/mDNSPosix/build/${objdir}/libjdns_sd.so
		dosym libjdns_sd.so /usr/$(get_libdir)/libjdns_sd.so.1
	fi

	newinitd "${FILESDIR}"/mdnsd.init.d mdnsd
	newinitd "${FILESDIR}"/mDNSResponderPosix.init.d mDNSResponderPosix
	newconfd "${FILESDIR}"/mDNSResponderPosix.conf.d mDNSResponderPosix
	newinitd "${FILESDIR}"/dnsextd.init.d dnsextd
	newconfd "${FILESDIR}"/dnsextd.conf.d dnsextd

	insinto /etc
	doins "${FILESDIR}"/mDNSResponderPosix.conf

	insinto /usr/include
	doins "${S}"/mDNSShared/dns_sd.h

	dodoc "${S}"/README.txt

	if use java; then
		java-pkg_dojar "${S}"/mDNSPosix/build/${objdir}/dns_sd.jar
		java-pkg_doso "${S}"/mDNSPosix/build/${objdir}/libjdns_sd.so
		use doc && java-pkg_dojavadoc "${S}"/mDNSPosix/build/${objdir}
	fi
}

pkg_postinst() {
	echo
	elog "To enable multicast dns lookups for applications"
	elog "that are not multicast dns aware, edit the 'hosts:'"
	elog "line in /etc/nsswitch.conf to include 'mdns', e.g.:"
	elog "hosts: files mdns dns"
	echo
}

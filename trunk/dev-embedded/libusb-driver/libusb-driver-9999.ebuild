# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit git-2

DESCRIPTION="Library which emulates the proprietary kernel module 'windrvr' in userspace."
HOMEPAGE="http://www.rmdir.de/~michael/xilinx/"
EGIT_REPO_URI="git://git.zerfleddert.de/usb-driver"
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="debug -ftdi +setup"
DEPEND="dev-libs/libusb:0
	ftdi? ( dev-embedded/libftdi )
	setup? ( sys-apps/sed )
	setup? ( sys-apps/fxload )"
RDEPEND="${DEPEND}"

src_install() {
	if use debug ; then
		newlib.so ${PN}-DEBUG.so ${PN}.so || die "newlib failed"
	else
		newlib.so ${PN}.so ${PN}.so || die "newlib failed"
	fi

	if use setup ; then
		dobin setup_pcusb || die "dobin failed"
	fi

	dodoc README || die "dodoc failed"
}

pkg_postinst() {
	elog
	elog "To use this library see /usr/share/doc/${PF}/README."
	elog
	if use setup ; then
		elog "To check if the initial firmware was loaded you can use the 'lsusb' tool from"
		elog "sys-apps/usbutils package. Simply run following command:"
		elog "  lsusb -d 03fd:"
		elog "If you see ID 03fd:0008, everything is done. Otherwise you can use setup_pcusb"
		elog "script to load the firmware."
		elog
	fi
}

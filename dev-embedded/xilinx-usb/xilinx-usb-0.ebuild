# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Firmwares for Xilinx USB JTAG"
HOMEPAGE="http://www.xilinx.com/support/download/"
LICENSE="XILINX"
SLOT="0"
KEYWORDS="amd64 ~x86"
DEPEND="
	sys-apps/sed"
RDEPEND="
	virtual/udev
	sys-apps/fxload"

S=${WORKDIR}

src_install() {
	# cp files/xusb*.hex /usr/share/
	insinto /usr/share
	doins "${FILESDIR}"/xusb*.hex || die

	# cp files/xusbdfwu.rules /etc/udev/rules.d/
	insinto /etc/udev/rules.d/
	doins "${FILESDIR}"/*.rules || die

	# sed -i -e 's/TEMPNODE/tempnode/' -e 's/SYSFS/ATTRS/g' -e 's/BUS/SUBSYSTEMS/' /etc/udev/rules.d/xusbdfwu.rules
	sed -i -e 's/TEMPNODE/tempnode/' -e 's/SYSFS/ATTRS/g' -e 's/BUS/SUBSYSTEMS/' ${ED}/etc/udev/rules.d/xusbdfwu.rules
}

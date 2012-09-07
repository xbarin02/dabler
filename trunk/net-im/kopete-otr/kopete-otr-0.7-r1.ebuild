# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

ARTS_REQUIRED="never"

inherit kde

DESCRIPTION="This plugin enables Off-The-Record encryption for the KDE instant messenger Kopete."
HOMEPAGE="http://kopete-otr.follefuder.org/"
SRC_URI="mirror://kde-sunset/kopete-otr-0.7.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND=">=net-libs/libotr-3.1.0
	kde-base/kopete:3.5"

need-kde 3.5

src_unpack() {
	kde_src_unpack
	rm -f "${S}/configure"

	cd src/
	epatch "${FILESDIR}/${P}-otrlchatinterface.patch"
}

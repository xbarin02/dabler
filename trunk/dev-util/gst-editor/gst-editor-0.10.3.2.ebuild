# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

DESCRIPTION="Graphical pipeline editor for GStreamer-0.10.x"
SRC_URI="http://${PN}.googlecode.com/files/${P/-/}.tar.gz"
HOMEPAGE="http://code.google.com/p/gst-editor/"
KEYWORDS="amd64"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="media-libs/gstreamer:0.10
	gnome-base/libglade
	x11-libs/goocanvas:0
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P/-/}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
}

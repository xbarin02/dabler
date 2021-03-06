# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit gst-plugins10
DESCRIPTION="Adaboost Facedetector - detects frontal faces in image"
HOMEPAGE="http://www.fit.vutbr.cz/~imlich/prods.php?id=154"
SRC_URI="http://www.fit.vutbr.cz/~imlich/prods.php?file=%2Fproduct%2F154%2Fgstabr2.tar.gz&id=154 -> gstabr2.tar.gz"
LICENSE="LGPL"
SLOT="0.10"
KEYWORDS="amd64"

DEPEND="media-libs/gstreamer:0.10"
RDEPEND="${DEPEND}"

S=${WORKDIR}/gstabr2

src_prepare() {
	emake clean || die "emake clean failed"
}

src_configure() {
	econf --with-package-name="DaBler GStreamer Ebuild" --with-package-origin="http://code.google.com/p/dabler/" || die "econf failed"
}

src_install() {
	einstall || die "einstall failed"
}

pkg_postinst() {
	elog "Start with: gst-launch-0.10 v4l2src ! videoscale ! video/x-raw-yuv, width=160, height=120 ! ffmpegcolorspace ! video/x-raw-gray ! abr2 ! ffmpegcolorspace ! ximagesink"
}

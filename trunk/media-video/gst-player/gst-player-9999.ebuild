# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils git-2

DESCRIPTION="A very basic media player that uses GStreamer"
HOMEPAGE="http://code.google.com/p/gst-player/"
EGIT_REPO_URI="git://github.com/felipec/gst-player.git"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""
DEPEND="media-libs/gstreamer:0.10
	media-libs/gst-plugins-base:0.10
	x11-libs/gtk+:2"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-Makefile-fix.patch" || die "epatch failed!"
}

src_install() {
	dobin "${PN}" || die "dobin failed!"
}

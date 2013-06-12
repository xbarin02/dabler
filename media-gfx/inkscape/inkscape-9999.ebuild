# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit bzr autotools

DESCRIPTION="A SVG based generic vector-drawing program"
HOMEPAGE="http://www.inkscape.org/"
EBZR_REPO_URI="lp:inkscape"
SLOT="0"
LICENSE="GPL-2 LGPL-2.1"
KEYWORDS="~amd64"
IUSE="lcms cairo wpg -dbus -gtk3 gnome inkjar -perl -python nls spell"

CDEPEND="
	dev-libs/glib
	dev-cpp/glibmm
	dev-libs/libxslt
	dev-libs/atk
	dev-cpp/atkmm
	x11-libs/pango
	dev-cpp/pangomm
	dev-libs/libsigc++:2
	x11-libs/gdk-pixbuf:2
	dev-libs/expat
	dev-libs/popt
	dev-libs/libxml2:2
	dev-libs/boehm-gc
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	media-gfx/imagemagick
	sci-libs/gsl
	x11-libs/libX11
	media-libs/libpng
	cairo? (
		app-text/poppler[cairo]
		x11-libs/cairo
		dev-cpp/cairomm
	)
	gtk3? (
		x11-libs/gtk+:3
		dev-cpp/gtkmm:3.0
	)
	!gtk3? (
		x11-libs/gtk+:2
		dev-cpp/gtkmm:2.4
	)
	spell? (
		app-text/aspell
		app-text/gtkspell
	)
	gnome? (
		gnome-base/gnome-vfs:2
	)
	lcms? (
		media-libs/lcms:2
	)
	dbus? (
		sys-apps/dbus dev-libs/dbus-glib
	)
	wpg? (
		app-text/libwpg:0.2
		app-text/libwpd:0.9
	)
	perl? (
		dev-lang/perl
	)
	python? (
		dev-lang/python
	)
"

RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}
	virtual/pkgconfig
	dev-util/intltool
	sys-devel/gettext
"

src_prepare() {
	./autogen.sh
}

src_configure() {
	econf \
		$(use_enable lcms) \
		$(use_enable cairo poppler-cairo) \
		$(use_enable wpg) \
		$(use_enable dbus dbusapi) \
		$(use_enable gtk3 gtk3-experimental) \
		$(use_enable nls) \
		$(use_with gnome gnome-vfs) \
		$(use_with inkjar) \
		$(use_with perl) \
		$(use_with python)
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc README
}

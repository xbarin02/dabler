# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit cmake-utils subversion 

DESCRIPTION="A completely OpenSourced alternative to the OpenGL Utility Toolkit (GLUT) library"
HOMEPAGE="http://freeglut.sourceforge.net/"
ESVN_REPO_URI="https://freeglut.svn.sourceforge.net/svnroot/freeglut/trunk/freeglut/freeglut"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 ~sh ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND="virtual/glu
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXext
	>=x11-libs/libXi-1.3
	x11-libs/libXrandr
	x11-libs/libXxf86vm"
DEPEND="${RDEPEND}
	x11-proto/inputproto
	x11-proto/xproto"

DOCS="AUTHORS ChangeLog NEWS README TODO"

src_install() {
	cmake-utils_src_install
	dohtml -r doc
}

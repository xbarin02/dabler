# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit cmake-utils

DESCRIPTION="Medical Data Segmentation Toolkit (MDSTk)"
HOMEPAGE="http://mdstk.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN,,}/${PN}-v${PV}.zip"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"

IUSE="debug doc +static-libs +modules opengl vector fftw xml"

CDEPEND="
	opengl? ( media-libs/freeglut virtual/opengl virtual/glu )
	doc? ( app-doc/doxygen[dot] )
	fftw? ( sci-libs/fftw )
	dev-cpp/eigen:3
	virtual/jpeg
	media-libs/libpng
	sys-libs/zlib
	media-libs/freeglut
"
DEPEND="${CDEPEND}
	sys-apps/grep
	app-arch/unzip"
RDEPEND="${CDEPEND}"

S="${WORKDIR}/${PN}"

cpu_has() { grep $1 /proc/cpuinfo > /dev/null && echo ON || echo OFF ; }

mds_use_enabled() { echo "-DMDS_${1}_ENABLED=$(use $2 && echo ON || echo OFF)" ; }

is_64bit() { [ "${ARCH}" == "amd64" ] && echo ON || echo OFF ; }

src_prepare() {
	epatch "${FILESDIR}/${P}-new-libpng.patch"
}

src_configure() {
	mycmakeargs=(
		-DMDS_PREFER_SUPPLIED_3RDPARTY_LIBS=OFF
		$(cmake-utils_use_build doc DOCUMENTATION)
		$(cmake-utils_use_build static-libs LIBRARIES)
		$(cmake-utils_use_build modules MODULES)
		$(cmake-utils_use_build opengl OPENGL_MODULES)
		-DBUILD_TESTS=OFF
		$(cmake-utils_use_build vector VECTOR_ENTITY)
		-DEIGEN_DONT_VECTORIZE=OFF
		-DEIGEN_ENABLE_ALTIVEC=$(cpu_has altivec)
		-DEIGEN_ENABLE_SSE2=$(cpu_has sse2)
		-DEIGEN_ENABLE_SSE3=$(cpu_has pni)
		-DEIGEN_ENABLE_SSSE3=$(cpu_has ssse3)
		-DMDSTk_3RDPARTY_DIR=${EROOT}usr
		-DMDS_EXPLICIT_TEMPLATE_INSTANTIATION=ON
		$(mds_use_enabled FFTW fftw)
		-DMDS_GENERATE_64BIT_CODE=$(is_64bit)
		-DMDS_LOGGING_DISABLED=OFF
		-DMDS_MULTITHREADED=ON
		-DMDS_OPENCV_ENABLED=OFF
		-DMDS_UMFPACK_ENABLED=OFF
		$(mds_use_enabled XML xml)
		-DTIXML_USE_STL=ON
	)

	cmake-utils_src_configure
	cmake-utils_src_configure
}

src_compile() {
	enable_cmake-utils_src_compile
	use doc && enable_cmake-utils_src_compile doc
}

src_install() {
	cmake-utils_src_install
	if use doc ; then
		dohtml -r doc
		cd "${CMAKE_BUILD_DIR}"
		dohtml -r doc
	fi
}

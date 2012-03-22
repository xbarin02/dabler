# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

MY_P=${P/-bin/}
MY_PN=${PN/-bin/}
MY_ARCH="${CHOST%%-*}"
case ${ARCH} in
	amd64) MY_CODE=a5d0b30 ;;
	x86)   MY_CODE=14fcbd9 ;;
	*) die "Unsupported archtecture" ;;
esac

DESCRIPTION="An automatic parallelizing and optimizing compiler (workbench) for C and Fortran sequential programs"
HOMEPAGE="http://www.par4all.org/"
SRC_URI="http://download.par4all.org/releases/debian/${MY_ARCH}/${PV}/${MY_P}-${MY_CODE}_${MY_ARCH}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="-* amd64 ~x86"
IUSE="cuda"

DEPEND="sys-apps/sed"
RDEPEND="dev-util/cproto
	sys-devel/gcc[fortran,openmp]
	sci-visualization/gnuplot
	dev-python/ipython[gnuplot]
	dev-libs/mpfr
	sys-libs/ncurses:5
	dev-lang/python:2.7[ncurses,readline]
	sys-libs/readline dev-python/ply
	cuda? ( dev-util/nvidia-cuda-toolkit )"

src_install()
{
	dodir /usr
	cp -R "${MY_P}" "${ED}"/usr/"${MY_PN}"
	dosym ../lib/python2.7/site-packages/pips/p4a.py /usr/"${MY_PN}"/bin/p4a
	sed -i "s|/usr/local/|/usr/|" "${ED}"/usr/"${MY_PN}"/etc/par4all-rc.*sh
	sed -i "s|/usr/local/${MY_PN}|/usr/${MY_PN}|g" "${ED}"/usr/"${MY_PN}"/lib/python2.7/site-packages/pips/*.py
}

pkg_postinst()
{
	elog
	elog "You will then need to source one of the following shell scripts which set up"
	elog "the environment variables for proper Par4All execution:"
	elog
	elog " * if you use bash, sh, dash, etc.:"
	elog "   source ${EPREFIX}/usr/par4all/etc/par4all-rc.sh"
	elog
	elog " * if you use csh, tcsh, etc.:"
	elog "   source ${EPREFIX}/usr/par4all/etc/par4all-rc.csh"
	elog
	elog "Once you set your environment up, you can, for example, run p4a -h to get help"
	elog "about the usage of the p4a frontend script."
	elog

	if use cuda; then
		elog "To compile and to run the cuda and OpenCL output, you should have the following"
		elog "environment variables set:"
		elog
		elog " * CUDA_DIR to the directory where cuda has been installed"
		elog " * LD_LIBRARY_PATH should contains at least \$CUDA_DIR/lib64"
		elog
	fi
}

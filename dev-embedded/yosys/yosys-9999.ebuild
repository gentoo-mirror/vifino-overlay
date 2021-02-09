# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python3_{5,6,7,8} )
inherit eutils git-r3 python-any-r1

DESCRIPTION="Yosys - Yosys Open SYnthesis Suite"
HOMEPAGE="http://www.clifford.at/icestorm/"
LICENSE="ISC"
EGIT_REPO_URI="https://github.com/cliffordwolf/yosys.git"
ABC_REPO_URI="https://github.com/YosysHQ/abc"

SLOT="0"
KEYWORDS=""
IUSE="+abc"

RDEPEND="
	sys-libs/readline:=
	virtual/libffi
	dev-vcs/git
	dev-lang/tcl:=
	dev-vcs/mercurial"

DEPEND="
	${PYTHON_DEPS}
	sys-devel/bison
	sys-devel/flex
	sys-apps/gawk
	virtual/pkgconfig
	${RDEPEND}"

src_configure() {
	emake config-gcc
	echo "ENABLE_ABC := $(usex abc 1 0)" >> "${S}/Makefile.conf"
	elog "patching Makefile to compile abc without cloning"
	sed -i 's/ABCREV\ =.*/ABCREV = default/g' "${S}/Makefile"
}

src_compile() {
	emake PREFIX="${EPREFIX}/usr"
}

src_install() {
	emake PREFIX="${ED}/usr" STRIP=true install
}

src_unpack() {
	git-r3_checkout

	elog "cloning abc"
	git-r3_fetch $ABC_REPO_URI HEAD latest
	git-r3_checkout $ABC_REPO_URI ${WORKDIR}/${P}/abc latest
}


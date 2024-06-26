# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Epson Inkjet Printer Driver (ESC/P-R)"
HOMEPAGE="https://download.ebz.epson.net/dsc/search/01/search/?OSC=LX"

# https://support.epson.net/linux/Printer/LSB_distribution_pages/en/escpr.php
# Use the "source package for arm CPU" to get a tarball instead of an srpm.
SRC_URI="https://download3.ebz.epson.net/dsc/f/03/00/15/68/89/fbff579f15226ffcc4a16895bd6bce6842277802/${P}-1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

DEPEND="net-print/cups"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/1.6.5-warnings.patch"
	"${FILESDIR}/${PN}-1.7.7-fnocommon.patch"
	"${FILESDIR}/${P}-1-missing-include.patch"
)

src_configure() {
	econf --disable-shared

	# Makefile calls ls to generate a file list which is included in Makefile.am
	# Set the collation to C to avoid automake being called automatically
	unset LC_ALL
	export LC_COLLATE=C
}

src_install() {
	emake -C ppd DESTDIR="${D}" install
	emake -C src DESTDIR="${D}" install
	einstalldocs
}

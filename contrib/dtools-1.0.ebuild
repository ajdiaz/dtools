# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib

DESCRIPTION="Distributed tools to run commands concurrently in many hosts."
HOMEPAGE="http://connectical.com/projects/show/dtools"
SRC_URI="http://files.connectical.com/gentoo/${PN}-${PV}.tar.gz"

LICENSE="GPL2"
SLOT="1"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE=""

DEPEND=">=app-shells/bash-3.2
	 	>=net-misc/openssh-4.6
		>=sys-apps/util-linux-2.13
		>=sys-apps/grep-2.5.0"

RDEPEND="$DEPEND"

src_install() {
	sed -i s:/usr/lib/:/usr/$(get_libdir)/:g ${PN}/dt
	sed -i s:/usr/lib/:/usr/$(get_libdir)/:g ${PN}/dt.1
	sed -i s:/usr/lib/:/usr/$(get_libdir)/:g ${PN}/dt.1.rst

	doman ${PN}/dt.1
	dodoc ${PN}/dt.1.rst
	dobin ${PN}/dt
	dodir /usr/$(get_libdir)/dtools
	insinto usr/$(get_libdir)/dtools
	doins ${PN}/lib/*.bash
}


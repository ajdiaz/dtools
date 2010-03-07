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

DEPEND=">=app-shells/bash-4.0
	 	>=net-misc/openssh-4.6
		>=sys-apps/util-linux-2.13"

RDEPEND="$DEPEND"

src_install() {
	sed -i s:/usr/lib/:/usr/$(get_libdir)/:g ${PN}/dt
	sed -i s:/usr/lib/:/usr/$(get_libdir)/:g ${PN}/dthost
	sed -i s:/usr/lib/:/usr/$(get_libdir)/:g ${PN}/dtstatus
	sed -i s:/usr/lib/:/usr/$(get_libdir)/:g ${PN}/doc/man/dt.1
	sed -i s:/usr/lib/:/usr/$(get_libdir)/:g ${PN}/doc/man/dthost.1
	sed -i s:/usr/lib/:/usr/$(get_libdir)/:g ${PN}/doc/man/dtstatus.1

	doman ${PN}/doc/man/dt.1
	doman ${PN}/doc/man/dthost.1
	doman ${PN}/doc/man/dtstatus.1

	dobin ${PN}/dt
	dobin ${PN}/dthost
	dobin ${PN}/dtstatus

	dodir /usr/$(get_libdir)/dtools
	insinto usr/$(get_libdir)/dtools
	doins ${PN}/lib/commands/*.bash
	doins ${PN}/lib/patterns/*.bash
}


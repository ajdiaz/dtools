#! /bin/bash
# Distributed Tools - dtools - lib/commands/add.bash
# Copyright (C) 2008 Andrés J. Díaz <ajdiaz@connectical.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

# The runner is callled from main dt script, and pass one argument (the
# first one) which contains the remote hostname, and probably a list of
# arguments for that command passed to dt on command line.
run ()
{
	local h="$1"; shift

	dtdb_addhost "$h" >> ${DTOOLS_DB:-/dev/null}
	local r=$?
	[ $# -ne 0 ] && dtdb_addtag "$h" "$@" && return $?
	return $r
}

help "add host to dtools database" \
"usage: add [tag]+

This module add a properly hosts with matching pattern to dtools database
using ssh-keyscan(1). A list of initial tagging can be added.
"

#! /bin/bash
# Distributed Tools - dtools - lib/telnet.bash
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
	local u="${LOGNAME}"
	local a=()
	local h="$1" ; shift
	req nc || E=3 err $"cannot found required binary nc"

	while [[ "$1" == -* ]]; do
		case "$1" in
			-*)  a[${#a[@]}]="$1" ;;
		esac
		shift
	done

	[ $# -lt 1 ] && E=3 err $"missing arguments"

	nc "${a[@]}" "${h}" "$@"
}

help "send a string over plain connection" \
"usage: nc [nc_opts] <command>

This command send the string provided as 'command' to remote hosts using
a plain connection. The nc_opts is a list of valid options for BSD netcat or
GNU netcat nc(1).
"


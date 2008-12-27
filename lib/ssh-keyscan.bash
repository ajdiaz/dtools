#! /bin/bash
# Distributed Tools - dtools - lib/key.bash
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
	req ssh-keyscan || E=3 err $"cannot found required binary ssh-keyscan"

	# If host already in known_hosts fails, but not abort
	if grep -q -e "^$h[,[:space:]]" -e "^.*,$h[:space:]" "${dt_lst}"; then
		echo "already known"
		return 1
	fi

	ssh-keyscan "$@" "$h" 2>/dev/null >> "${dt_lst}"
}

help "usage: key [key_opts]

This module add a properly ssh key from hosts with matching pattern to
known_hosts(5) database using ssh-keyscan(1). The key_tops are ssh-keyscan
options.
"

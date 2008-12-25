#! /bin/bash
# Distributed Tools - dtools - lib/ping.bash
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
	local r
	local h="$1" ; shift
	req ping || E=3 err $"cannot found required binary ping"

	r="$(ping -q -c 1 -W 5 "$@" "${h}" 2>&1)"

	if [ "$?" -ne 0 ]; then
		echo "${r#ping: }"
		return 1
	fi

	IFS=','
	while read x y z t; do
		[ "$t" ] && echo "${t# time }"
	done <<<"$r"

}

help "usage: ping [ping_opts]

This module pings the hosts which match with pattern host
and return the latency. If fails a error message is returned.
You can use here any of the options for the ping(1) command.
"

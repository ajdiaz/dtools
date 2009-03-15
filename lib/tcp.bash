#! /bin/bash
# Distributed Tools - dtools - lib/tcp.bash
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

let tcp_cnt=10

# The runner is callled from main dt script, and pass one argument (the
# first one) which contains the remote hostname, and probably a list of
# arguments for that command passed to dt on command line.
run ()
{
	local h="$1" ; shift
	req nc || E=3 err $"cannot found required binary ssh"

	if [ "$1" == "-wait" ]; then
		local wait=true
		shift
	fi

	[ $# -lt 2 ] && E=3 err $"missing arguments"

	local p="$1" ; shift

	if ${wait:-false} ; then
		exec 4<>/dev/tcp/${h}/${p}
		echo "$@" >&4
		cat <&4
	else
		echo "$@" >/dev/tcp/${h}/${p}
	fi
}

help "send a string over TCP connection using directly socket" \
"usage: tcp [-wait] <port> <string>

This command is similar to nc command, but use directly TCP socket, provided
by bash (if enabled in compiled-time). This command open a TCP connection
against the hosts over port specified in arguments and, finally, send the
string.

By default the tcp commands do not wait for a server response, but the option
-wait change this behaviour and force dt to wait for an EOF in the connection.
"


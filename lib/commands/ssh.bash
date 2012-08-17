#! /bin/bash
# Distributed Tools - dtools - lib/commands/ssh.bash
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

ssh ()
{
	local h="$1"; shift
	SSHOPTS="$SSHOPTS -oStrictHostKeyChecking=no"
	if ${interactive:-false} ; then
		#command ssh $SSHOPTS -oKbdInteractiveAuthentication=no \
		#	-oBatchMode=yes "$h" ":" >&2 2>/dev/null
		#[ $? -eq 0 ] || input "ssh" "$h" "hidden" >/dev/tty
 		SSHOPTS="${SSHOPTS} -oNumberofPasswordPrompts=1"
	else
		SSHOPTS="$SSHOPTS -oLogLevel=ERROR -oBatchMode=yes"
	fi
	if [ "$SSHPROXY" ]; then
		local pu="$(dt_user $SSHPROXY)"
		local ph="$(dt_host $SSHPROXY)"
		local pp="$(dt_port $SSHPROXY)"

    	eval command ssh $SSHOPTS ${pp:+-p $pp} ${pu:+$pu@}$ph \"ssh $SSHOPTS "$h" \'"$@"\'\"
    else
	    eval command ssh $SSHOPTS "$h" \'"$@"\'
	fi
}

# The runner is callled from main dt script, and pass one argument (the
# first one) which contains the remote hostname, and probably a list of
# arguments for that command passed to dt on command line.
run ()
{
	local h="$(dt_host "$1")"
	local u="$(dt_user "$1")"
	local p="$(dt_port "$1")"
	local proxy="$(dt_proxy "$1")"
	shift

	req ssh || E=3 err $"cannot found required binary ssh"

	[ $# -lt 1 ] && E=3 err $"missing arguments"

	SSHPROXY="$proxy" SSHOPTS="$SSHOPTS ${p:+-p $p}" ssh "${u}@${h}" "$@"
}

help "execute a command in remote hosts" \
"usage: ssh [ssh_opts] <command>

This module runs the system command passed as argument in the remote machine
and return the output. You can use any of the ssh(1) program options as
ssh_opts.
"


#! /bin/bash
# Distributed Tools - dtools - lib/commands/script.bash
# Copyright (C) 2010 Andrés J. Díaz <ajdiaz@connectical.com>
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

lib "commands/ssh.bash" || \
	E=2 err $"script module depends of ssh"

lib "commands/scp.bash" || \
	E=2 err $"script module depends of scp"

# The runner is callled from main dt script, and pass one argument (the
# first one) which contains the remote hostname, and probably a list of
# arguments for that command passed to dt on command line.
run ()
{
	local h="$1" ; shift
	local a=()
	local u="$LOGNAME"
	req ssh || E=3 err $"cannot found required binary ssh"
	req scp || E=3 err $"cannot found required binary scp"

	while [[ "$1" == -* ]]; do
		case "$1" in
			-user) local u="$2" ; shift ;;
			-*) a[${#a[@]}]="$1" ;;
		esac
		shift
	done

	local s="$1"; shift
	scp "$s" "${u}@${h}:.dt.script.$$" &&
		ssh "${u}@${h}" "${a[@]}" "chmod 755 .dt.script.$$ &&
		./.dt.script.$$ ${@} ; rm -f .dt.script.$$"
}

help "execute a local script in remote hosts" \
"usage: script [-user <user>] [ssh_opts] <script file>

This module run a local script in affected hosts via ssh.
"


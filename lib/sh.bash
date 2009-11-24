#! /bin/bash
# Distributed Tools - dtools - lib/sh.bash
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
	req ssh || E=3 err $"cannot found required binary ssh"

	while [[ "$1" == -* ]]; do
		case "$1" in
			-dt:user)  local u="$2" ; shift ;;
			-*)  a[${#a[@]}]="$1" ;;
		esac
		shift
	done

	[ $# -lt 1 ] && E=3 err $"missing arguments"

	if ${interactive:-false}; then
		echo -n "$h " >&3
	fi
	ssh "${a[@]}" "${u}@${h}" "$@"
}

help "execute a command in remote hosts" \
"usage: sh [-dt:user <user>] [ssh_opts] <command>

This module runs the system command passed as argument in the remote machine
and return the output. You can use any of the ssh(1) program options as
ssh_opts. By default use BatchMode=true, so no interactively command is
allowed. The -dt:user option sets the user who connecto to remote host.
"


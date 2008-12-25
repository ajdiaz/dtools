#! /bin/bash
# Distributed Tools - dtools - lib/rscp.bash
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
	local l="${HOSTNAME:-$(hostname -f 2>/dev/null)}"

	[ "$l" ] || E=3 err $"cannot get FQDN of local hostname"
	req ssh  || E=3 err $"cannot found required binary ssh"

	while [[ "$1" == -* ]]; do
		case "$1" in
			-u)  local u="$2" ; shift ;;
			-*)  a[${#a[@]}]="$1" ;;
		esac
		shift
	done

	[ $# -lt 1 ] && E=3 err $"missing arguments"

	ssh -oBatchMode=true "${u:+${u}@}${h}" "scp" \
		"-q" "${a[@]}" "${1}" "${LOGNAME:-${u}}@${l}:${2:-$PWD}"
}

help "usage: rscp [-u <user>] [scp_opts] <remote_file> [local_file]

This module copy a file from a list of remote hosts to local host (it's the
symetric command of scp, but reverse). The -u option can set the remote user
to logon. You can set a list of scp(1) options which will be passed to
remote scp program when copy file to local host. The remote_file is the file
path to be copy to here and local_file is the local path where file must be
copy on. If local_file is not present, the file might be copied to working
directory.
"

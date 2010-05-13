#! /bin/bash
# Distributed Tools - dtools - lib/commands/scp.bash
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

scp ()
{
	local remote=
	local fsrc="$1"; shift
	local fdst="$1"; shift

	local rsrc="${fsrc%%:*}"
	local rdst="${fdst%%:*}"

	[ "$rsrc" != "$fsrc" ] && remote="${remote:+$remote,}$rsrc"
	[ "$rdst" != "$fdst" ] && remote="${remote:+$remote,}$rdst"

	SSHOPTS="-oStrictHostKeyChecking=no"
	if ${interactive:-false} ; then
 		SSHOPTS="${SSHOPTS} -oNumberofPasswordPrompts=1"
		input "scp" "${remote}" "hidden"
	else
		SSHOPTS="$SSHOPTS -oBatchMode=yes"
	fi
	command scp -q $SSHOPTS "$@" $fsrc $fdst
}

# The runner is callled from main dt script, and pass one argument (the
# first one) which contains the remote hostname, and probably a list of
# arguments for that command passed to dt on command line.
run ()
{
	local u="${LOGNAME}"
	local a=()
	local h="$1" ; shift
	req scp || E=3 err $"cannot found required binary scp"

	while [[ "$1" == -* ]]; do
		case "$1" in
			-user) local u="$2" ; shift ;;
			-*) a[${#a[@]}]="$1" ;;
		esac
		shift
	done

	[ $# -lt 1 ] && E=3 err $"missing arguments"

	scp "$1" "${u}@${h}:${2}" "${a[@]}"
}

help "classic scp copy to hosts" \
"usage: scp [-user <user>] [scp_opts] <local_file> [remote_file]

This module distribute a local file to a remote hosts which match with
the pattern. You can use the -user option to set the remote user to use,
if not defined use the same as running dt. Also you can pass any scp(1)
option. The local_file is the local file to copy on, and the remote file is
the remote file (for all hosts) where the file must be put in on. You can
copy a directory using the -r option of scp. If remote_file is not present,
copy to HOME.
"

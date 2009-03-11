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

# This is a mandatory to main dt script. This mandatory key forces dt
# to do not fork any command of this kind. Use always -i option (or -T 0)
interactive=true

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

	cat "${@}" |
	ssh "${a[@]}" "${u}@${h}" \
		"mkdir -p ~/.ssh &&
		cat >> ~/.ssh/authorized_keys &&
		chmod 644 ~/.ssh/authorized_keys"
}


help "distribute a public key in hosts" \
"usage: key-send [-dt:user <user>] <key_file>+

This module adds the public key file passed as argument into remote
authorized_keys for hosts with match with pattern. This module is similar to
the ssh-keysend functionality. You can set also a remote user to login.

Note: this module take not care about if hosts already added on remote
authorized_keys file.
"

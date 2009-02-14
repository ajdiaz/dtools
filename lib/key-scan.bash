#! /bin/bash
# Distributed Tools - dtools - lib/pubkey.bash
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
	req ping || E=3 err $"cannot found required binary ping"

	# If host already in known_hosts fails, but not abort
	if grep -q -e "^$h[,[:space:]]" \
			   -e "^.*,$h[:space:]" "${dt_lst}" 2>/dev/null
	then
		echo $"already known"
		return 1
	fi

	if [ -r "${dt_lst}" ]; then
		read wc_prev file <<<"$(wc -l "${dt_lst}")"
	else
		wc_prev=0
	fi

	# XXX keyscan only works with SSH2. This is a default hardcoded
	# configuration due to security considerations. If you need SSH
	# 1 enabled, then set the properly value for the -t argument in
	# ssh-keyscan caller.
	ssh-keyscan -trsa,dsa "$@" "$h" 2>/dev/null >> "${dt_lst}"

	if [ -r "${dt_lst}" ]; then
		read wc_last file <<<"$(wc -l "${dt_lst}")"
	else
		wc_last=0
	fi

	if [ "$wc_prev" -eq "$wc_last" ]; then
		echo $"unable to retrieve keys"
		return 1
	else
		echo "$(( $wc_last - $wc_prev))" $"key(s) retrieved"
		return 0
	fi
}

help "add key from host to known_host database" \
"usage: key-scan [key_opts]

This module add a properly ssh key from hosts with matching pattern to
known_hosts(5) database using ssh-keyscan(1). The key_tops are ssh-keyscan
options.
"

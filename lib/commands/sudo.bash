#! /bin/bash
# Distributed Tools - dtools - lib/commands/sudo.bash
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

lib "commands/ssh.bash" || \
	E=2 err $"sudo depends of ssh module"

sudo ()
{
	local h="$1" ; shift

	if ${interactive:-false} ; then
		ssh "$h" -tt sudo -S -p \""$(input sudo $h hidden Password 3>&1)"\" "$@" >&3 
	else
		ssh "$h" sudo "$@"
	fi
}

# The runner is callled from main dt script, and pass one argument (the
# first one) which contains the remote hostname, and probably a list of
# arguments for that command passed to dt on command line.
run ()
{
	local u="${LOGNAME}"
	local h="$1" ; shift

	while [[ "$1" == -* ]]; do
		case "$1" in
			-user)  local u="$2" ; shift ;;
			-*)  a[${#a[@]}]="$1" ;;
		esac
		shift
	done
	sudo "${u}@${h}" "$@"
}

help "execute a command in remote hosts with privilegies" \
"usage: sudo [-user <user>] [sudo_opts] <command>

This modules runs a command in remote hosts using sudo.
Obviously the sudo binary must be exists in remote host. The
sudo_opts are a list of options for sudo(1).

NOTE: The -user is used to set the user who connect to remote
host, but not is necessary the same as user for sudo, you can use
the sudo(1) option -u to do this.
"


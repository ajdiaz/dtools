#! /bin/bash
# Distributed Tools - dtools - lib/commands/local.bash
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
	local c="$1"; shift

	[ "$h" ] || [ "$c" ] || E=1 err "host and command are required."

	$c "$h" "$@"
}

help "perform local commands" \
"usage: local [command] [args]+

This command allows you to run a command in the current host, instead of
distribute an action. The command passed as argument will be run for each
host, which is also passed as argument. For example, a 'local echo' command
will result in a 'echo hostname' for each hostname  resolved by the dtools
pattern.
"

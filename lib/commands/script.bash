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

script () {
	local s="$1"; shift
	local shabang="$( head -1 "${s}" )"

    if [ "$shabang" != "${shabang#\#!}" ]; then
        local shabang="${shabang#\#!}"
    else
        local shabang=/bin/sh
    fi

    cat "$s" | ssh "$1" "$shabang"
}

# The runner is callled from main dt script, and pass one argument (the
# first one) which contains the remote hostname, and probably a list of
# arguments for that command passed to dt on command line.
run ()
{
	local u="$(dt_user "$1")"
	local h="$(dt_host "$1")"
	shift

	req ssh || E=3 err $"cannot found required binary ssh"

	script "$1" "${u}@${h}"
}

help "execute a local script in remote hosts" \
"usage: script [ssh_opts] <script file>

This module run a local script in affected hosts via ssh.
"


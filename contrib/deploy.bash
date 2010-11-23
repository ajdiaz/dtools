#! /bin/bash
# Distributed Tools - dtools - contrib/deploy.bash
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
	E=2 err $"script module depends of ssh"

lib "commands/scp.bash" || \
	E=2 err $"script module depends of scp"

# The runner is callled from main dt script, and pass one argument (the
# first one) which contains the remote hostname, and probably a list of
# arguments for that command passed to dt on command line.
run ()
{
	local h="$(dt_host "$1")"
	local u="$(dt_user "$1")"
	shift

	local u="$LOGNAME"
	req ssh || E=3 err $"cannot found required binary ssh"
	req scp || E=3 err $"cannot found required binary scp"

	release="$(date "+%Y-%m-%d")"

    git archive --format tar  master | \
        gzip -9 > "${TMPDIR:-/tmp}/deploy-${release}" && \
    scp "${TMPDIR:-/tmp}/deploy-${release}" "${u}@${h}:$1" && \
    ssh "${u}@${h}" "mkdir -p $1/${release} && tar xvzf $1/deploy-${release} -C $1/${release}"
}

help "deploy an application to hosts" \
"usage: deploy [ssh_opts] dir

This module works only if you are in git repository, then deploy a copy
of the repository to remote hosts in specified dir passed as argument.
"


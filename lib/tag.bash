#! /bin/bash
# Distributed Tools - dtools - lib/tag.bash
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
	local h="$1" ; shift

	[ $# -eq 0 ] && _tag_lst "$h" || for tag in "$@" ; do
		_tag_mod "$h" "$tag"
	done
}

_tag_lst ()
{
	local arg="$1" ; shift
	while read host ktype key tags ; do
		local h1="${host#*,}"
		local h2="${host%,*}"

		case $arg in
			$h1|$h2) : echo -n "${tags// /,}" && break
		esac

	done < "${dt_lst}"
}


_tag_del ()
{
	# Here is a big line :D
	sed -i \
		-e "s:^\\($1\\)[[:space:]]\\(.*\\)[[:space:]]\\(.*\\)[[:space:]]$2[[:space:]]:\\1 \\2 \\3 :" \
		-e "s:^\\($1\\)[[:space:]]\\(.*\\)[[:space:]]\\(.*\\)[[:space:]]$2\$:\\1 \\2 \\3 :" \
		"${dt_lst}"
	sed -i \
		-e "s:^\\(.*,$1\\)[[:space:]]\\(.*\\)[[:space:]]\\(.*\\)[[:space:]]$2[[:space:]]:\\1 \\2 \\3 :" \
		-e "s:^\\(.*,$1\\)[[:space:]]\\(.*\\)[[:space:]]\\(.*\\)[[:space:]]$2\$:\\1 \\2 \\3 :" \
		"${dt_lst}"
}

_tag_add ()
{
	# Here are a big line :D
	sed -i "s:^\\($1\\)[[:space:]]\\(.*\\):\\1 \\2 $2:" "${dt_lst}"
	sed -i "s:^\\(.*,$1\\)[[:space:]]\\(.*\\):\\1 \\2 $2:" "${dt_lst}"
}

_tag_mod ()
{
	local h="$1"; shift
	local tag
	while [ "$#" -ne 0 ]; do
		case "$1" in
			-*) tag="${1#-}" && _tag_del "$h" "$tag" ;;
			 *) tag="$1" && _tag_add "$h" "$tag" ;;
		esac
		shift
	done
}

help "manage tagging features" \
"usage: tag [tag_to_add] [-tag_to_del]

This module allow to add tags to hosts which match with specified pattern.
If tag name is preceding with minus operation sign (-) then tag is deleted
from hosts with match with pattern. If no tag name is providing then current
tags are listed.
"

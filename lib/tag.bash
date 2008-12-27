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

	if [ $# -lt 1 ]; then
		_tag_list "$@"
		return 0
	fi

	IFS=','
	for tag in $1 ; do
		case "$tag" in

			-*)
			tag="${tag#-}"
			if _tag_find "$h" "$tag" ; then
				_tag_remove "$h" "$tag" || return 1
				echo -n "$tag:"
			fi
			;;

			**)
			tag="${tag#+}"
			_tag_find "$h" "$tag" && continue
			_tag_add "$h" "$tag" || return 1
			echo -n "$tag:"
			;;
		esac
	done
	echo
}

_tag_remove ()
{
	sed -i "/^$1[,[:space:]]/s/tag:\\(.*\\)$2[,]*/tag:\\1/g" "${dt_lst}" &&
	sed -i "/^.*,$1[:space:]/s/tag:\\(.*\\)$2[,]*/tag:\\1/g" "${dt_lst}"
}

_tag_add ()
{
	if ! _tag_mark "$@"; then
		sed -i "/^$1[,[:space:]]/s/$/ tag:$2,/g" "${dt_lst}" &&
		sed -i "/^.*,$1[:space:]/s/$/ tag:$2,/g" "${dt_lst}"
	else
		sed -i "/^$1[,[:space:]]/s/$/$2,/g" "${dt_lst}" &&
		sed -i "/^.*,$1[:space:]/s/$/$2,/g" "${dt_lst}"
	fi
}

_tag_find ()
{
	grep -e "^$1[,[:space:]]" -e "^.*,$1[:space:]" "${dt_lst}" |
	grep -q -e "tag:$2[,]*" -e "tag:.*,$2[,]*"
}

_tag_mark ()
{
	grep -e "^$1[,[:space:]]" -e "^.*,$1[:space:]" "${dt_lst}" |
	grep -q -e "[[:space:]]tag:"
}

_tag_list ()
{
	read h t k tags \
		<<<"$(grep -e "^$1[,[:space:]]" -e "^.*,$1[:space:]" "${dt_lst}")"
	local tags="${tags#tag:}"
	echo "${tags//,/:}"
}

help "usage: tag [tag_op]

This module allow to add tags to hosts which match with specified pattern.
You must provide a valid tag operation. You can read the dt(1) manual for
more information about tag operations. If operation is not present, then
the action return the present tags in matched hosts.
"

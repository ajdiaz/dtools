#! /bin/bash
# Distributed Tools - dtools - lib/pattern/out.bash
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

help "pattern to get hosts from external source" \
"This pattern get a list of hosts (one per line) from stdin"

pattern_out ()
{
	while read host trash; do
		[ "${host:1:1}" == "#" ] && continue
		[ "${#host}" -eq 0 ] && continue
		echo "$host"
	done

}

pattern "out" pattern_out
return 0

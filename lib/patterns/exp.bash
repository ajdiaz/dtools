#! /bin/bash
# Distributed Tools - dtools - lib/pattern/exp.bash
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

help "match for host given a regular expression" \
"This pattern return the hosts which match for the regular expression passed
as argument."

pattern_exp ()
{
	[ -r ${DTOOLS_DB:-/dev/null} ] || return 0
	while read host tags ; do
		case "$(expr match "$host" "$1")" in
			0) ;;
			*) echo "$host" ;;
		esac
	done < ${DTOOLS_DB:-/dev/null}
}

pattern "exp" pattern_exp
return 0


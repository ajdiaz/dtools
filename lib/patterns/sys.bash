#! /bin/bash
# Distributed Tools - dtools - lib/pattern/sys.bash
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

help "dummy pattern which return the string passed as argument" \
"This pattern always return the string passed as argument as comma
separated values, for example host1,host2 return the list composed by
both hostnames."

pattern_sys ()
{
	echo "${1//,/ }"
}

pattern "sys" pattern_sys
return 0

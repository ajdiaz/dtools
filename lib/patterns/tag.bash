#! /bin/bash
# Distributed Tools - dtools - lib/pattern/tag.bash
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

help "match for hosts with solve the tag operation" \
"This pattern return the hosts which solve the specific tag operation.
A tag operation is a list of pairs tag and operation where tag is a valid
tag string and operation is symbol to operate the tags, valid symbols are
, (OR), - (EXCEPT) or + (AND)."

pattern_tag ()
{
	dtdb_findtag "$1"
}

pattern "tag" pattern_tag
return 0


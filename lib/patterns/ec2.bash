#! /bin/bash
# Distributed Tools - dtools - lib/pattern/ec2.bash
# Copyright (C) 2012 Andrés J. Díaz <ajdiaz@connectical.com>
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

req "ec2-describe-tags" || return 0

help "match for host in AWS EC2 using tags" \
"This pattern return the hosts which match for tags passed
as argument using EC2 API (which is a requiremente). Also
EC2_PRIVATE_KEY and EC2_CERT variables must be defined in the
environment. You can use tag@region to filter the tag in an
specific region"

pattern_ec2 ()
{
	[ "$EC2_CERT" ]        || E=1 err "no EC2_CERT defined"
	[ "$EC2_PRIVATE_KEY" ] || E=1 err "no EC2_PRIVATE_KEY defined"

	local regions=()

	while read keyword region other; do
		regions[${#regions[@]}]="$region"
	done <<<"$(ec2dre)"

	for region in "${regions[@]}"; do
		[ "${1//@/}" != "${1}" ] && [ "$region" != "${1##*@}" ] && continue
		while read k1 k2 instance keytag tag; do
			echo $instance
		done <<<"$(ec2dtag --region "$region")"
	done
}

pattern "ec2" pattern_ec2
return 0


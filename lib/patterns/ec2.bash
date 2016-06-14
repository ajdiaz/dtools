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


help "match for host in AWS EC2 using tags" \
"This pattern return the hosts which match for tags passed
as argument using EC2 API (which is a requiremente). Also

export AWS_ACCESS_KEY_ID=AKI...
export AWS_SECRET_ACCESS_KEY=...
export AWS_DEFAULT_REGION=us-east-1

Is required to define key and region for this pattern.

Basic usage:

  dt ec2:tag=Label=Value list

  dt ec2:tag=Name=myhost-01 list

Which is equivalent to:

  dt ec2:myhost-01

And you can use globs here:

  dt ec2:myhost-*

  dt ec2:sec=default list

Which is equivalent to:

  dt ec2:group-name=default list
"


parse_paravirtual () {
  IFS=$'\t' read -r _ _ _ hack _ _ _ _ _ _ _ _ os data1 data2 data3 _ <<<"$1"
  case "$hack" in
    False|True) echo "$data1" ;;
    *) 
      case "$os" in
        windows) echo "$data3";;
        *) echo "$data2";;
      esac;;
  esac
}

parse_hvm () {
  IFS=$'\t' read -r _ _ _ hack _ _ _ _ _ _ _ os data1 data2 data3 _ <<<"$1"
  case "$hack" in
    False|True) echo "$data1" ;;
    *) 
      case "$os" in
        windows) echo "$data3";;
        *) echo "$data2";;
      esac;;
  esac

}

parse_vpc () {
  IFS=$'\t' read -r _ _ _ _ _ _ _ _ _ _ _ _ _ data _ <<<"$1"
  [ "$data" ] || echo "$1"
}


pattern_ec2 ()
{
    req "aws" || E=1 err "awscli is required"

	[ "$AWS_ACCESS_KEY_ID" ] || E=1 err "no AWS_ACCESS_KEY_ID defined"
	[ "$AWS_SECRET_ACCESS_KEY" ] || E=1 err "no AWS_SECRET_ACCESS_KEY defined"

	export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-us-east-1}"

  local fval=
  local fnam=

  case "$1" in
     sec=*)
         IFS='=' read fnam fval <<<"$1"
         fnam="group-name"
         ;;
     tag=*)
         IFS='=' read fnam fnam fval <<<"$1"
         fnam="tag:$fnam";;
     *=*)
         IFS='=' read fnam fval <<<"$1"
         ;;
     *)
         fnam="tag:Name"
         fval="$1"
         ;;
  esac

  local _awsargs="Name=$fnam,Values=$fval"
  local _ip=

  while read line; do
    case "$line" in
      INSTANCE*) ;;
      *) continue;;
    esac
    kind="${line##*$'\t'}"
    case "$kind" in
      paravirtual) parse_paravirtual "$line";;
      hvm) parse_hvm "$line";;
      vpc-*) parse_vpc "$line";;
    esac
  done < <(aws --output=text ec2 describe-instances \
               --filters Name=instance-state-name,Values=running \
               $_awsargs)
}

pattern "ec2" pattern_ec2
return 0


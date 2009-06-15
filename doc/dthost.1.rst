======
dthost
======
distributed tools
"""""""""""""""""

:Date: 2009-06-15
:Author: Andres J. Diaz <ajdiaz@connectical.com>


SYNOPSIS
========

    command | dthost

DESCRIPTION
===========

dthost is an OMNI parses wich group result by fiveth field (the hostname).
This is similar to group_host theme in old versions of dtools. You can use
this filter for dt, in the following way::

    $ dt <exp|tag> <command> [args] | dthost

This will be output the command executed by dt grouping by hostname.

SEE ALSO
========

    ssh(1), ssh-keyscan(1),dt(1),dtstatus(1),dtcli(1)


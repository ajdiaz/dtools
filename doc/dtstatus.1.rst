========
dtstatus
========
distributed tools
"""""""""""""""""

:Date: 2009-06-15
:Author: Andres J. Diaz <ajdiaz@connectical.com>


SYNOPSIS
========

    command | dtstatus

DESCRIPTION
===========

dtstatus is an OMNI parses wich group result by first field (the status).
This is similar to group_status theme in old versions of dtools. You can use
this filter for dt, in the following way::

    $ dt <exp|tag> <command> [args] | dtstatus

This will be output the command executed by dt grouping by status.

SEE ALSO
========

    ssh(1), ssh-keyscan(1),dt(1),dthost(1),dtcli(1)


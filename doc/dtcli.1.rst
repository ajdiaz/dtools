=====
dtcli
=====
distributed tools
"""""""""""""""""

:Date: 2009-06-15
:Author: Andres J. Diaz <ajdiaz@connectical.com>


SYNOPSIS
========

    dtcli [context]

DESCRIPTION
===========

dtcli is a interactive shell for dtools, the shell works in a single way:
each typed line is a dt invocation in the form::

    <exp|tag> <command> [arguments]

If context exists, the the context always preceding the typed text, so each
line will be converted to:

    [context] <exp|tag> <command> [arguments]

There are some special commands:

:help
  Show a short help screen

:env [context|'NULL']
  Set or remove the context to specified value passed as argument, if
  argument is equal to NULL (literally), then environment will be removed.

EXAMPLES
========

Using dtcli in this way::

    dtcli exp:.*

And the commands::

    ssh echo a

The result will be a echoed a in all hosts defined in known database.

Using dtcli in this way:

    dtcli exp:.* ssh

And command:

    echo a

Will be produced the same results.

SEE ALSO
========

    ssh(1), ssh-keyscan(1),dt(1),dthost(1),dtstatus(1)


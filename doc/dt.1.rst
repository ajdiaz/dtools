==
dt
==
distributed tools
"""""""""""""""""

:Date: 2008-12-30
:Author: Andres J. Diaz <ajdiaz@connectical.com>


SYNOPSIS
========

    dt [options] <host_pattern> <command> [arguments]

DESCRIPTION
===========

Distributed tools, aka dtools is a suite of programs to manage remotely
a number of UNIX systems across SSH connection.

The **dt** command is the main frontend for Distributed Tools. The **dt**
command allows you to execute the *command* passed as argument in the host
list identified by *host_pattern*.

HOST PATTERN
============

The host patterns using in **dt** can use one of the following forms:

* Regular expression, using the prefix ``exp:`` before the regular
  expression in perl format as described in regexp(7).

* Tag operation, using the prefix ``tag:`` before the tag operation. A tag
  operation is a list, comma separated, of valid tags. Read the section
  `Tags`_ below for more information.

* Host or multiple host directly, without prefix the host pattern then the
  host pattern is interpreted as hostname (or multiple hostnames
  comma-separated).

* A reserved keyword ``all`` which is an alias to ``exp:.*``, that is,
  affect to all registered hosts.

OPTIONS
=======

-h [value]
    Print a short help and exits. If *value* is present then print help
    about specified command.

-p
    Pretend the command execution, do not really. Its's usefull to check the
    affected hosts.

-H <file>
    By default **dt** uses the ``known_hosts`` files provided by ssh(1), but
    you can specify another file in the same format using this option.

-t <theme>
    **This option is deprecated, read dtstatus(1), dthost(1) for more
    information**

-T <number>
    Dispatch the command in the specified number of threads (really use
    fork(2)).

-i
    Interactive mode, it's an alias to -T 0, that is, do not use any fork.

-N
    Supress color output always.


TAGS
====

Tags are labels in hosts. Each host in ``known_host`` file use the 5th
parameter as tag definition. You can set a number of tags to a host using
the *tag* command.

You can operate with tags, with normal boolean operations: AND, OR, MINUS:

* tag1,tag2: tag1 AND tag2
* tag1,+tag2: tag1 OR tag2
* tag1,-tag2: tag1 AND NOT tag2
* tag1,-tag2,+tag3: tag1 OR tag3 BUT NOT tag2

COMMANDS
========

The COMMANDS section in this manual is no longer available, please use
reference in dt -h <command>.

FILTERING
=========

By default the **dt** output format is OMNI compatible, it's easy to parse
and easy to read by humans, but in some situations (for example when command
returns a long number of lines) we need other format to keep the results
human-readable. So, for that situations, you can filtering the output using
a single pipeline, for example::

    $ dt exp:.* command | filter

There are a list of available filters:

* dtstatus(1)
* dthost(1)

EXAMPLES
========

Scan for a new host and add his public key into  known_hosts database::

    $ dt newhost.mydomain key-scan

Populate your public key to newhost without forks::

    $ dt -i exp:newhost.* key-send ~/.ssh/id_dsa.pub

Copy a file in the path /tmp/examplefile.txt from local host to the remote
host called externalhost.mydomain, and put there in home folder of the
user::

    $ dt externalhost.mydomain scp /tmp/examplefile.txt

Do again, but now put the file in remote /tmp directory::

    $ dt externalhost.mydomain scp /tmp/examplefile.txt /tmp

Do again, but now copy to all hosts with domain mydomain::

    $ dt exp:.*mydomain scp /tmp/examplefile.txt /tmp

Do again, but now copy to hosts tagged as hosts_in_china::

    $ dt tag:host_in_china scp /tmp/examplefile.txt /tmp

Do again, but runs only in one proccess (no-childs)::

    $ dt -T 0 tag:host_in_china scp /tmp/examplefile.txt /tmp

And now with 10 childs::

    $ dt -T 10 tag:host_in_china scp /tmp/examplefile.txt /tmp

But, hosts not in shangai::

    $ dt -T 10 tag:host_in_china,-host_in_changai \
        scp /tmp/examplefile.txt /tmp

Copy files from remote hosts to local (reverse copy). Copy the remote host
file /tmp/examplefile.txt to local /tmp::

    $ dt externalhost.mydomain rscp /tmp/examplefile.txt /tmp

Do a ping to two hosts, but use multihost feature::

    $ dt externalhost1.mydomain,externahost2.mydomain ping

Do a ping to all and print the results grouping by status::

    $ dt -t status_group exp:.* ping

Reboot machines using IPMI interface::

    $ dt exp:.* ipmi power cycle


RETURN VALUES
=============

The *dt* returns zero when command is sucessfully running, or other value
when error. The error code 2 means an error with arguments, and the value
3 means an error in module.

OUTPUT
======

The output uses the OMNI format, that is::

{okay|fail}::dt:<command>:<host>:<message>

It's easy to parse with cut(1) and awk(1). The new line symbol in output is
scaped.

FILES
=====

~/.ssh/dt.known_hosts
    This file is used as master host database for **dt**.

ENVIRONMENT
===========

DTOOLS_LIB
    By default **dt** search for command modules in /usr/lib/dtools
    directory, but if this variable is present, search in the path provide
    as content.

RELATED PROJECTS
================

* PyDSH - http://pydsh.sourceforge.net/index.php
* DCMD - http://sourceforge.net/projects/dcmd
* DSH - http://sourceforge.net/projects/dsh
* DSSH - http://dssh.subverted.net/

SEE ALSO
========

    ssh(1), ssh-keyscan(1), dtcli(1), dtstatus(1), dthost(1)


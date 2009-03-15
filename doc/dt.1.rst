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
    Use specified theme as output theme for **dt**. By default use OMNI
    compatible theme, separated by two colons. Read the `THEMES`_ section
    below for more information.

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

nc [nc_opts] <command>
----------------------

This command send the string provided as 'command' to remote hosts using
a plain connection. The nc_opts is a list of valid options for BSD netcat or
GNU netcat nc(1).

key-send [-dt:user <user>] <key_file>+
--------------------------------------

This module adds the public key file passed as argument into remote
authorized_keys for hosts with match with pattern. This module is similar to
the ssh-keysend functionality. You can set also a remote user to login.

Note: this module take not care about if hosts already added on remote
authorized_keys file.

ping [ping_opts]
----------------

This module pings the hosts which match with pattern host
and return the latency. If fails a error message is returned.
You can use here any of the options for the ping(1) command.

key-scan [key_opts]
-------------------

This module add a properly ssh key from hosts with matching pattern to
known_hosts(5) database using ssh-keyscan(1). The key_tops are ssh-keyscan
options.

rscp [-dt:user <user>] [scp_opts] <remote_file> [local_file]
------------------------------------------------------------

This module copy a file from a list of remote hosts to local host (it's the
symetric command of scp, but reverse). The -u option can set the remote
user to logon. You can set a list of scp(1) options which will be passed to
remote scp program when copy file to local host. The remote_file is the
file path to be copy to here and local_file is the local path where file
must be copy on. If local_file is not present, the file might be copied to
working directory.


scp [-dt:user <user>] [scp_opts] <local_file> [remote_file]
-----------------------------------------------------------

This module distribute a local file to a remote hosts which match with
the pattern. You can use the -u option to set the remote user to use,
if not defined use the same as running dt. Also you can pass any scp(1)
option. The local_file is the local file to copy on, and the remote file is
the remote file (for all hosts) where the file must be put in on. You can
copy a directory using the -r option of scp. If remote_file is not present,
copy to HOME.

sh [ssh_opts] <command>
-----------------------

This module runs the system command passed as argument in the remote machine
and return the output. You can use any of the ssh(1) program options as
ssh_opts. By default use BatchMode=true, so no interactively command is
allowed.

sudo [-dt:user <user>] [sudo_opts] <command>
--------------------------------------------

Eexecute a command in remote hosts with privilegies.

This modules runs a command in remote hosts using sudo.
Obviously the sudo binary must be exists in remote host. The
sudo_opts are a list of options for sudo(1).

**NOTE:** The -dt:user is used to set the user who connect to remote
host, but not is necessary the same as user for sudo, you can use
the sudo(1) option -u to do this.

By default the sudo module runs in batch mode, so no password prompting is
allowed, if you have a interactive sudo configuration, you need to run dt
with -i flag (enabling the interactive mode). A -T 0 option must be works
fine too.

tag [tag_op]
------------

This module allow to add tags to hosts which match with specified pattern.
You must provide a valid tag operation. You can read the dt(1) manual for
more information about tag operations. If operation is not present, then
the action return the present tags in matched hosts.

tcp [-wait] <port> <string>
---------------------------

This command is similar to nc command, but use directly TCP socket, provided
by bash (if enabled in compiled-time). This command open a TCP connection
against the hosts over port specified in arguments and, finally, send the
string.

By default the tcp commands do not wait for a server response, but the option
-wait change this behaviour and force dt to wait for an EOF in the connection.

udp <port> <string>
-------------------

This command is similar to nc command, but use directly UDP socket, provided
by bash (if enabled in compiled-time). This command sends UDP packets
to the hosts over port specified in arguments.

THEMES
======

By default the **dt** output format is OMNI compatible, it's easy to parse
and easy to read by humans, but in some situations (for example when command
returns a long number of lines) we need other format to keep the results
human-readable. So, you can specify another theme using the -t option in
command line. There are a list of core themes:

* *status_group*  The status group theme grouping the results by their
  return status (okay or fail), and it's usefull for commands with short
  response (like ping).

* *host_group*  The host group theme grouping the results by the host, this
  is esentially the same as default theme, but evaluate new line symbols and
  it's very usefull when a command return among of results, for example
  a remote cat of file or similar.

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


RETURN VALUES
=============

The *dt* returns zero when command is sucessfully running, or other value
when error. The error code 2 means an error with arguments, and the value
3 means an error in module.

OUTPUT
======

The output uses the OMNI format, that is::

{okay|fail}::dt:<command>:<message>

It's easy to parse with cut(1) and awk(1). The new line symbol in output is
scaped.

You can use specific themes related in `THEMES`_ section of this manual.

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

    ssh(1), ssh-keyscan(1)


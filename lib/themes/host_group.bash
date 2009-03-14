# -- This a theme for dt(1). Read the manpage for more information about
# presentation themes or visit the project page in http://connectical.com

# okay_hook (command, host, message)
okay () {
	echo -e "${G}okay${N}:$1:${H}$2${N}:$(
	echo -e  \\n\\040 ${3//\\n/\\n\\040 } \\n)\n"
}

# fail_hook (command, host, message)
fail () {
	echo -e "${R}fail${N}:$1:${H}$2${N}:$(
	echo -e  \\n\\040 ${3//\\n/\\n\\040 } \\n)\n"
}



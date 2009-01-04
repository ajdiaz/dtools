# -- This a theme for dt(1). Read the manpage for more information about
# presentation themes or visit the project page in http://connectical.com

# okay_hook (command, host, message)
okay () {
	echo okay "${@}"
}

# fail_hook (command, host, message)
fail () {
	echo fail "${@}"
}

# show_hook ()
show () {
	local a_okay=()
	local a_fail=()

	while read status command host message ; do
		case "$status" in
			okay) a_okay[${#a_okay[@]}]="${H}$host${N} => $message" ;;
			fail) a_fail[${#a_fail[@]}]="${H}$host${N} => $message" ;;
		esac
	done

	if [ ${#a_okay[@]} -gt 0 ]; then
		echo "${G}okay${N}:"
		for item in "${a_okay[@]}" ; do
			echo -e "  $item"
		done
	fi

	echo

	if [ ${#a_fail[@]} -gt 0 ]; then
		echo "${R}fail${N}:"
		for item in "${a_fail[@]}" ; do
			echo -e "  $item"
		done
	fi

	echo

}


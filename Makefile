DESTDIR ?= /usr

all:
	@echo No make required for this project

install:
	@mkdir -p ${DESTDIR}/{lib,bin}
	@cp -r lib ${DESTDIR}/lib/dtools
	@cp -r dt dtcompact dthost dtstatus dtsh ${DESTDIR}/bin


# vim:ft=make
#

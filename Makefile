PREFIX ?= /usr/local

install:
	install -Dm755 -t "${DESTDIR}${PREFIX}/bin/" backup
	install -Dm640 -t "${DESTDIR}/etc/backup/" example.env
	install -Dm640 -t "${DESTDIR}/etc/backup/" example.exclude

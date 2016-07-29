INSTALLDIR=/opt/bytemine-idb
NAME=bytemine-idb-puppetintegration
VERSION=0.3
UPLOAD_CMD=scp /tmp/$(NAME)-$(VERSION).tar.gz bytemine-www@files.bytemine.net:/data/www/allgemein/files.bytemine.net/

install:
	mkdir -p $(PREFIX)$(INSTALLDIR)
	cp -r puppet $(PREFIX)$(INSTALLDIR)

distfile:
	rm -rf /tmp/$(NAME)-$(VERSION)
	mkdir /tmp/$(NAME)-$(VERSION)
	cp -R . /tmp/$(NAME)-$(VERSION)/
	cd /tmp/$(NAME)-$(VERSION)/ && rm -rf .git
	cd /tmp && tar czfv /tmp/$(NAME)-$(VERSION).tar.gz \
                $(NAME)-$(VERSION)/

upload: distfile
	$(UPLOAD_CMD)

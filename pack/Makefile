all: install
.PHONY: all install test clean npminstall reinstall

TINYPATH = $(realpath ./bin)
MOCHAPATH = $(realpath ./node_modules/mocha/bin)

npminstall:
	-npm install --registry=http://registry.npm.taobao.org;

cmd:
	-chmod +x $(TINYPATH)/tinygame;
	-ln -s $(TINYPATH)/tinygame /usr/local/bin/tinygame;
	-ln -s $(MOCHAPATH)/mocha /usr/local/bin/mocha;

install: npminstall cmd test

test:
	-mocha --reporter list

clean:
	-for package in `ls node_modules`;\
	do\
		npm uninstall $$package;\
	done;
	-rm -rf node_modules;
	-chmod -x ./bin/tinygame;
	-rm -f /usr/local/bin/tinygame;
	-rm -f /usr/local/bin/mocha;

reinstall: clean install

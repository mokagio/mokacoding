serve:
	./node_modules/http-server/bin/http-server -p 8000

build:
	node ./metallo/build.js
	mv feed.html feed.xml

watch:
	node ./metallo/build.js
	mv feed.html feed.xml
	node ./metallo/watch.js

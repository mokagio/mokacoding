serve:
	./node_modules/http-server/bin/http-server -p 8000

build:
	node ./metallo/build.js

watch:
	build
	node ./metallo/watch.js

serve:
	cd ./dist && ../node_modules/http-server/bin/http-server -p 8000

build:
	node ./metallo/build.js

dev_build:
	node ./metallo/build.js --dev

watch:
	node ./metallo/build.js
	node ./metallo/watch.js

.DEFAULT_GOAL := build

node_modules: package.json
	npm install

build: node_modules
	node ./metallo/build.js

dev_build: node_modules
	node ./metallo/build.js --dev

serve: node_modules build
	cd ./docs && ../node_modules/http-server/bin/http-server -p 8000

watch: node_modules
	node ./metallo/build.js
	node ./metallo/watch.js

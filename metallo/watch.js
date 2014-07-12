var watch = require('node-watch');
var exec = require('child_process').exec;

function puts(error, stdout, stderr) {
	if (stdout) { console.log(stdout); }
	if (stderr) { console.log(stderr); }
}

var baseDir = process.cwd() + "/metallo";
var watched = [
	baseDir + "/src",
	baseDir + "/build.js",
	baseDir + "/../package.json"
	];
watch(watched, function(filename) {
	console.log(filename, 'changed. Re-buildind...');
	exec("node " + baseDir + "/build.js", puts);
});

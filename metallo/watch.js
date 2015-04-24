var watch = require('node-watch');
var exec = require('child_process').exec;

function puts(error, stdout, stderr) {
	if (stdout) { console.log(stdout); }
	if (stderr) { console.log(stderr); }
}

var anti_filter = function(pattern, fn) {
  return function(filename) {
    if (!pattern.test(filename)) {
      fn(filename);
    }
  }
}

var baseDir = process.cwd() + "/metallo";
var watched = [
	baseDir + "/src",
	baseDir + "/build.js",
	baseDir + "/../package.json"
	];
watch(watched, anti_filter(/\.swp$/, function(filename) {
	console.log(filename, 'changed. Re-buildind...');
	exec("node " + baseDir + "/build.js", puts);
}));

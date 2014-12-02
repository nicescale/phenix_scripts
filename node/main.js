var fs = require('fs');
var path = require('path');

var parse = function(text) {
  var lines = text.split('\n');
  return lines;
};

var load_cheatsheet_in_dir = function(dir) {
  var filenames = fs.readdirSync(dir);
  var cheatsheets = [];
  filenames.forEach(function(filename) {
    var fullpath = path.join(dir, filename);
    var stats = fs.lstatSync(fullpath);
    if (stats.isFile() || stats.isSymbolicLink()) {
      cheatsheets.push({
        content: parse(fs.readFileSync(fullpath, 'utf-8')),
        name: filename
      });
    } else if (stats.isDirectory()) {
      cheatsheets = cheatsheets.concat(load_cheatsheet_in_dir(fullpath));
    }
  });
  return cheatsheets;
};

exports.get_cheatsheets = function() {
  return load_cheatsheet_in_dir(
      path.join(__dirname, '../online_cheatsheet'));
};

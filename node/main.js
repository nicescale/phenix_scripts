var fs = require('fs');
var path = require('path');

var parse = function(text) {
  return text.split('\n').filter(function(line) {
    return line.length > 0;
  }).map(function(line) {
    var result = /^\s*#(.*)$/.exec(line);
    if (result) {
      return {
        type: 'text',
        value: result[1].trim()
      };
    } else {
      return {
        type: 'code',
        value: line
      };
    }
  });
};

var load_cheatsheet_in_dir = function(dir) {
  var filenames = fs.readdirSync(dir);
  var cheatsheets = [];
  filenames.forEach(function(filename) {
    var fullpath = path.join(dir, filename);
    var stats = fs.lstatSync(fullpath);
    if (stats.isFile() || stats.isSymbolicLink()) {
      cheatsheets.push({
        contents: parse(fs.readFileSync(fullpath, 'utf-8')),
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

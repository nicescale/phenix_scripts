var fs = require('fs');
var path = require('path');
var get_cheatsheets = require('./main').get_cheatsheets;

fs.writeFileSync(path.join(__dirname, 'cheatsheets.json'),
                 JSON.stringify(get_cheatsheets()));

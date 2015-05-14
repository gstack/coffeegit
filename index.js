// the rest of the package is in coffeescript
// so load it and expose it
require('coffee-script/register');
var Coffeegit = module.exports = require('./init');

if (require.main === module)
{
  Coffeegit.start();
}

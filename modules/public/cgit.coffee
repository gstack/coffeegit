# Requires
_ = require 'lodash'
fs = require 'fs'
cgi = require 'cgi'
path = require 'path'
util = require 'util'
extend = require 'extend'
require 'colors'

# /home/git/coffeegit/cgit
cgi_dir = path.resolve __dirname, '..', '..', 'cgi-bin'
cgit_bin = path.join cgi_dir, 'cgit.cgi'
cgit_rc = path.join cgi_dir, '..', 'cgitrc'

if not fs.existsSync(cgit_bin)
  util.log(("cannot find cgit executable in #{cgi_dir} - the public git module that uses it wont be available.").yellow)
  return

if not fs.existsSync(cgit_rc)
  util.log(("cannot find cgit config in #{cgit_rc} - the public git module that uses it wont be available.").yellow)
  return

util.log((cgit_bin + ' found').white)
util.log((cgit_rc + ' found').white)

# cgit cgi passthru server
module.exports = (Coffeegit, server, app) ->

  cgi_handler = (req, res) ->
    if not Coffeegit.public_cgit and not req.session.logged_in
      res.redirect('/login')
      return

    opts = { mountPoint: '/cgit', env: { "CGIT_CONFIG": cgit_rc } }
    cgi(cgit_bin, opts)(req, res)

  # register the route
  #app.use '/', (req, res) ->
  #  cgi_handler(req, res)
  #app.use '/*', (req, res) ->
  #  cgi_handler(req, res)

  app.route('/cgit*').all(cgi_handler)

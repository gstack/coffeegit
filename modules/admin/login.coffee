# Requires
Handlebars = require 'handlebars'
webutils = require '../webutils'
_ = require 'lodash'
fs = require 'fs'
path = require 'path'
util = require 'util'
extend = require 'extend'
db = require '../db'

# path of the users.json (will be created if not exists)
auth_json = path.join(__dirname, '../..', 'db', 'auth.json')

# Login module
module.exports = (Coffeegit, server, app) ->
  # static path for templates and shxt
  web_folder = server.adminWeb
  template_path = path.join web_folder, 'templates', 'login.hbs'

  # precompiled templates
  tmpl = Handlebars.compile fs.readFileSync(template_path).toString()

  # register the route
  app.get '/login', (req, res) ->
    opts = { csrf: webutils.csrfToken() }
    if req.param 'msg' == '0'
      opts.reason = 'you are currently logged out'
    extend(opts, tmpl_opts)
    res.end tmpl(opts)
  # register the route
  app.post '/login', (req, res) ->
    opts = { sitename: Coffeegit.sitename, registered: false, reason: reason, user: user, csrf: webutils.csrfToken() }
    if not webutils.checkCsrf req.body.csrf
      register = false
      reason = 'invalid csrf token'
      options = { sitename: Coffeegit.sitename, registered: false, reason: reason, user: user, csrf: webutils.csrfToken() }
      res.end tmpl(options)
      util.log "invalid csrf! ip: (#{req.ip})".underline.red
      return

    user = req.body.user
    pass = req.body.pass

    user = user.trim()
    pass = pass.trim()

    login = false

    if not user or not pass or not user.trim().length or not pass.trim().length
      opts.reason = 'please put in a real username / pass'
    # register / write out
    user = user.toLowerCase()
    users = JSON.parse fs.readFileSync(auth_json)
    names = Object.keys users
    record = null
    if user in names
      login = true
      record = users[user]
      console.log record
    else
      opts.reason = 'user does not exist.'
      util.log(opts.reason.red)
      login = false

    if record and record.password != pass
      login = false
      opts.reason = 'login failed.'

    if login and record and record.password == pass
      req.session.logged_in = true
      req.session.username = record.user
      req.session.user = record.user
      req.session.fullname = record.fullname
      req.session.email = record.email
      util.log  (req.ip+' logged in as '+user).green
      res.redirect('dashboard')
      return
    else
      db.checkUser user, pass, (record) ->
        if record
          user = record.username
          util.log ('user can login with mysql: '+user).green
          req.session.logged_in = true
          req.session.username = record.user
          req.session.user = record.user
          req.session.fullname = record.fullname
          req.session.email = record.email
          util.log  (req.ip+' logged in as '+user).green
          res.redirect('dashboard')
        else
          #extend(opts, tmpl_opts)
          req.session.logged_in = false
          res.end tmpl(opts)

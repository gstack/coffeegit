# Requires
Handlebars = require 'handlebars'
webutils = require '../webutils'
_ = require 'lodash'
fs = require 'fs'
path = require 'path'
util = require 'util'
extend = require 'extend'
require 'colors'

# Registration
module.exports = (Coffeegit, server, app) ->

  # path of the users.json (will be created if not exists)
  auth_json = path.join(__dirname, '../..', 'db', 'auth.json')

  if not fs.existsSync(auth_json)
    auth = Coffeegit.Auth.plain
    fs.writeFileSync auth_json, JSON.stringify(auth)
    console.log "created auth.json @ #{auth_json} with #{auth.length} entries."

  # static path for templates and shxt
  web_folder = server.adminWeb
  template_path = path.join web_folder, 'templates', 'register.hbs'

  # precompiled templates
  tmpl = Handlebars.compile fs.readFileSync(template_path).toString()

  # stored regex
  test = new RegExp('([^0-9a-zA-Z])')

  # register the routes
  app.get '/register', (req, res) ->
    if not Coffeegit.registration
      res.end('sorry.')
      return

    tmpl_options = { sitename: Coffeegit.sitename }
    extend tmpl_options, { registered: false, csrf: webutils.csrfToken() }
    res.end tmpl(tmpl_options)

  app.post '/register', (req, res) ->
    if not Coffeegit.registration
      res.end('inb4 ban. go away')
      return

    tmpl_options = { sitename: Coffeegit.sitename }

    if not webutils.checkCsrf req.body.csrf
      register = false
      reason = 'invalid csrf token'
      extend tmpl_options, { registered: false, reason: reason, user: user, csrf: webutils.csrfToken() }
      res.end tmpl(tmpl_options)
      util.log "invalid csrf! ip: (#{req.ip})".underline.red
      return

    user = req.body.user
    pass = req.body.pass

    user = user.trim()
    pass = pass.trim()

    fullname = req.body.fullname || req.body.name
    email = req.body.email

    register = true

    if not user or not pass or not user.trim().length or not pass.trim().length
      register = false
      reason = 'please put in a real username / pass'

    if test.test user
      register = false
      reason = 'please enter a valid username (no special chars or spaces)'

    if not register
      res.end tmpl()
    else
      # register / write out
      users = JSON.parse fs.readFileSync(auth_json)
      names = Object.keys users
      user = user.toLowerCase()
      if user in names
        register = false
        reason = 'user already exists: '+user
        extend(tmpl_options, { registered: false, reason: reason, user: user, csrf: webutils.csrfToken() });
        res.end tmpl(tmpl_options)
        util.log reason.red + ' ' + (req.ip+'').white
      else
        users[user.toLowerCase()] = { user: user, password: pass, fullname: fullname, email: email }
        fs.writeFileSync auth_json, JSON.stringify(users)
        extend(tmpl_options, { registered: true, user: user, pass: pass, fullname: fullname, email: email })

        # complete login
        req.session.logged_in = true
        req.session.username = user
        req.session.user = user # lazy.. stored in 2 places
        req.session.fullname = users[user.toLowerCase()].fullname
        req.session.email = users[user.toLowerCase()].fullname

        #res.end tmpl(tmpl_options)
        util.log "registered #{user} / saved to #{auth_json}".green
        res.redirect 'dashboard'

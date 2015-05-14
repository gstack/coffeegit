# Requires
Handlebars = require 'handlebars'
webutils = require '../webutils'
_ = require 'lodash'
fs = require 'fs'
path = require 'path'
util = require 'util'
extend = require 'extend'
md5 = require 'MD5'

class Dashboard

  constructor: (Coffeegit, server, app) ->
    # static path for templates and shxt
    @web_folder = server.adminWeb
    @template_path = path.join web_folder, 'templates', 'dashboard.hbs'

    @cg = Coffeegit
    @server = server
    @app = app

    @tmpl_opts = { sitename: Coffeegit.sitename }

    if not @module
      @module = 'dashboard'

    if @register
      @register()
      util.log ('registered '+@module).green

  register: (app) ->
    # override with @app.etc('/', @run) calls.

  run: (req, res) ->
    # blank run - override
    util.log 'blank dashboard call. (run)'.red
    res.end(@template(req, res)({warning: 'dashboard_blank'}))

  # register the route
  template: (req, res) ->

    session = req.session

    if not session.logged_in
      res.redirect '/login?msg=0'
      return

    name = session.username
    tmpl = Handlebars.compile fs.readFileSync(template_path).toString()
    sidebar_tmpl = Handlebars.compile(fs.readFileSync(path.join @web_folder, 'templates', 'sidebar.hbs').toString())

    opts = { module: @module, page: @title, user: name, fullname: session.fullname, username: session.user, email: session.email, avatar: new Handlebars.SafeString('//www.gravatar.com/avatar/'+md5(session.email)+'?s=80'),  }

    opts.menu = sidebar_tmpl(server.menu)
    opts.sidebar = new Handlebars.SafeString('<ul class="sidebar-menu">'+opts.menu+'</ul>')
    #console.log(opts.menu)

    extend(opts, @tmpl_opts)
    req.opts = opts;

    # returns a wrapper function to build the dashboard page + inner module
    fn = (o) ->
      # automatically convert content to safe html string
      if typeof(o.content) != 'object'
        o.content = new Handlebars.SafeString(o.content)

      extend(o, opts)
      return tmpl(o)

    return fn

# try this new one
module.exports = Dashboard

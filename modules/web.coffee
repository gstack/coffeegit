# Coffeegit
fs = require 'fs'
path = require 'path'

CSON = require 'season'

# all aboard express..
express = require 'express'
express_session = require 'express-session'
bodyParser = require 'body-parser'
multer = require 'multer'

module.exports = (Coffeegit) ->

  class Coffeegit.Webserver

    # modules are coffeescript files loaded from the public & admin next to this file
    # they are loaded and passed an instance of this class, and the Coffeegit {}
    publicModules: ['hello', 'cgit'],
    adminModules: ['hello', 'login', 'register', 'dashboard', 'page', 'git', '../public/cgit', 'logout', 'redirect'],

    # admin side functions (this menu isn't currently used)
    menu: {
      items: [
        {
          title: 'Dashboard',
          href: 'dashboard'
        },
        {
          title: 'Git',
          items: [
            {
              title: 'Add Repo',
              href: 'git/create'
            },
            {
              title: 'Clone Repo',
              href: 'git/clone'
            }
          ]
        }
      ]
    },

    constructor: ->

      # automatically set port defaults
      Coffeegit.webPort = Coffeegit.webPort or 8001
      Coffeegit.adminPort = Coffeegit.adminPort or 8002

      @cg = Coffeegit

      if not @cg.ignorePublic
        @startPublic()

      if not @cg.ignoreAdmin
        @startAdmin()

    # start http server for public stuff (cgit pass-thru, gitweb, or custom features we add..)
    startPublic: ->
      @public = express()
      @registerPublic()
      @public.listen(@cg.webPort)
      console.log "public web server listening on #{@cg.webPort}"

    # start admin server for git management
    startAdmin: ->
      @admin = express()
      @registerAdmin()
      @admin.listen(@cg.adminPort)
      console.log "admin application server listening on #{@cg.adminPort}"

    # pull the public path by replacing this scripts directory path: modules -> web
    registerPublic: ->
      @publicWeb = (__dirname).replace 'modules', 'static'
      @publicWeb = path.join @publicWeb, 'public'
      @public.set 'trust proxy', 'loopback'

      @public.use(bodyParser.json()); # for parsing application/json
      @public.use(bodyParser.urlencoded({ extended: true })); # for parsing application/x-www-form-urlencoded
      @public.use(multer()); # for parsing multipart/form-data

      @public.use express.static(@publicWeb)

      for mod in @publicModules
        register = require path.join __dirname, 'public', mod
        register @cg, @, @public

      console.log "public modules: #{@publicModules.join ','} registered."

    registerAdmin: ->
      # admin actually depends on some static content of public too
      @publicWeb = (__dirname).replace 'modules', 'static'
      @publicWeb = path.join @publicWeb, 'public'

      @adminWeb = (__dirname).replace 'modules', 'static'
      @adminWeb = path.join @adminWeb, 'admin'

      @admin.use(bodyParser.json()); # for parsing application/json
      @admin.use(bodyParser.urlencoded({ extended: true })); # for parsing application/x-www-form-urlencoded
      @admin.use(multer()); # for parsing multipart/form-data

      @admin.use express_session({
        secret: @cg.sessionSecret,
        saveUninitialized: true
      })

      @admin.set 'trust proxy', 'loopback'
      @admin.use express.static(@publicWeb)
      @admin.use express.static(@adminWeb)

      for mod in @adminModules
        register = require path.join __dirname, 'admin', mod
        register @cg, @, @admin

      console.log "admin modules: #{@adminModules.join ','} registered."

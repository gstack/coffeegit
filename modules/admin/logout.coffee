# Requires
Handlebars = require 'handlebars'
webutils = require '../webutils'
_ = require 'lodash'
fs = require 'fs'
path = require 'path'
util = require 'util'
extend = require 'extend'

# Login module
module.exports = (Coffeegit, server, app) ->

  # static path for templates and shxt
  web_folder = server.adminWeb

  # register the route
  app.get '/logout', (req, res) ->
    req.session.logged_in = false
    res.redirect('login')

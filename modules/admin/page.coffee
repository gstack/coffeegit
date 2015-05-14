# Requires
Handlebars = require 'handlebars'
webutils = require '../webutils'
_ = require 'lodash'
fs = require 'fs'
path = require 'path'
util = require 'util'
extend = require 'extend'

Dashboard = require './dashboard'

# Page class
class Page extends Dashboard

  constructor: (Coffeegit, server, app) ->
    @module = 'page'
    super Coffeegit, server, app

  register: ->
    # gotta remember to bind.@ for these callbacks -> this object
    @app.get '/page', @page.bind @
    @app.get '/dashboard', @dashboard.bind @

  dashboard: (req, res) ->
    @module = 'dashboard'
    @title = 'Dashboard'
    tmpl = @template(req, res)
    res.redirect '/git/list'
    #res.end tmpl({title: 'Dashboard Home', content: '<p><b>sup?</b></p>'})

  page: (req, res) ->
    @module = 'page'
    @title = 'Page'
    tmpl = @template(req, res)
    res.end tmpl({title: 'Page Index', content: '<p>hey hey 123123</p>'})

module.exports = (Coffeegit, server, app) ->
  return new Page(Coffeegit, server, app)

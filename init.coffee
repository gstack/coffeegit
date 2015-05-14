# coffeegit v0.1
fs = require 'fs'
path = require 'path'
extend = require 'extend'
CSON = require 'season'

Coffeegit = {
  # Git config
  Git: {}

  # Auth config / dict
  Auth: {}
}

Coffeegit.tryConfig = ->
  config = path.join process.cwd(), 'config.cson'
  config = CSON.readFileSync config
  extend Coffeegit, config.Coffeegit
  extend Coffeegit.Git, config.Git
  extend Coffeegit.Auth, config.Auth

  console.log 'Loaded and applied configuration to Coffeegit'
  config # returns config

# Initialized from process, so start the HTTP server
Coffeegit.start = ->
  Coffeegit.tryConfig()
  require('./modules/web')(Coffeegit)
  
  global.cgConfig = Coffeegit
  Coffeegit.server = new Coffeegit.Webserver()


module.exports = Coffeegit

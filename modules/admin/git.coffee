# Requires
Handlebars = require 'handlebars'
webutils = require '../webutils'
_ = require 'lodash'
fs = require 'fs'
rpath = require 'path'
util = require 'util'
extend = require 'extend'
moment = require 'moment'
Repos = require '../repos'
require 'shelljs/global'

db = require '../db'

formutils = require '../formutils'

Dashboard = require './dashboard'

repos_tmpl = rpath.join(__dirname, '..', '..', 'db', 'cgitrepos.tmpl')
repo_dir = (global.cgConfig.Git.repoDir+"")

# Page class
class Git extends Dashboard

  constructor: (Coffeegit, server, app) ->
    @module = 'page'
    @cg = Coffeegit
    super Coffeegit, server, app

  register: ->
    # gotta remember to bind.@ for these callbacks -> this object
    @app.get '/git/add', @add.bind @
    @app.get '/git/clone', @clone.bind @
    @app.get '/git/list', @list.bind @
    @app.get '/git/rebuild', @rebuildlist.bind @
    @app.post '/git/add', @doadd.bind @
    @app.post '/git/clone', @doclone.bind @

  list: (req, res) ->
    @module = 'getrepos'
    @title = 'Repo List'

    db.getRepos ((data) ->
      html = """
      <div class="box box-solid box-info">
      <div class="box-header">
      <h3 class="box-title">Git Repos</h3>
      </div>
      <div class="box-body">
      """
      for repo, i in data
        #html += "<p>"+JSON.stringify(repo)+"</p>"
        html += '<div class="git-repo"><h4>'+"#{i+1}. "+repo.repo+'</h4>'
        html += '<p>Path: <b>'+repo.path+'</b></p>'
        html += '<p>Description: <i>'+repo.path+'</i></p>'
        html += '<p>Email: <i>'+repo.email+'</i></p>'
        html += '<p>url (clone): <i>'+repo.url+'</i></p>'
        html += '<p>Last Checked: '+moment(repo.last_check).fromNow()+'</p>'
        html += '<hr /></div>'

      html += "</div></div>"
      html += """<p><a href="/git/rebuild">rebuild cgitrepos list (automatically happens after every new repo or clone)</a></p>"""

      tmpl = @template(req, res)
      res.end tmpl({title: @title, content: html})
    ).bind @

  rebuildlist: (req, res) ->
    Repos.rewrite ->
      res.redirect('/git/list')

  add: (req, res) ->
    @module = 'addrepo'
    @title = 'Add Repo'

    form = formutils.form('POST', '/git/add', @title, [
      { type: 'text', name: 'name', 'label': 'Repo Name: ', placeholder: 'A-Za-z0-9 please'},
      { type: 'text', name: 'desc', 'label': 'Repo Description: ', placeholder: 'Whatever..'}
    ])

    tmpl = @template(req, res)
    res.end tmpl({title: @title, content: form})

  clone: (req, res) ->
    @module = 'clonerepo'
    @title = 'Clone Repo'

    #todo: sanatize
    form = formutils.form('POST', '/git/clone', @title, [
      { type: 'text', name: 'name', 'label': 'Repo Name: ', placeholder: 'name-goes-here'},
      { type: 'text', name: 'desc', 'label': 'Repo Description: ', placeholder: 'Whatever..'},
      { type: 'text', name: 'url', 'label': 'Repo Git URL: ', placeholder: 'git://whatever'},
    ])

    tmpl = @template(req, res)
    res.end tmpl({title: @title, content: form})

  doclone: (req, res) ->
    @module = 'clonerepo'
    @title = 'Clone Repo'

    name = req.body.name
    repo = req.body.url+''
    desc = req.body.desc+''

    try
      if not name or name.trim().length == 0
        name = repo.split('.git')[0].split('/')
        name = name[name.length-1]

      path = rpath.join(repo_dir, name)
      tmpl = @template(req, res)

      exec "git clone --mirror #{repo} #{path}",((code, output) ->
        console.log 'output code: '+code
        console.log 'git output: '+output

        if (code == 0)
          output += '... Done!'

        output += " Exit Code: #{code}"

        Repos.clone name, desc, path, repo, req.session.email
        res.end tmpl({title: @title, content: output})
      ).bind @
    catch ex
      tmpl = @template(req, res)
      res.end tmpl({title: @title, content: ex.message})

  doadd: (req, res) ->
    @module = 'addrepo'
    @title = 'Add Repo'

    name = req.body.name.trim().toLowerCase()
    desc = req.body.desc+''

    try
      if not name or name.trim().length == 0
        res.end tmpl({title: @title, content: "Enter a real name -.-"})
        return

      path = rpath.join(repo_dir, name)
      tmpl = @template(req, res)

      exec "git init --bare #{path}",((code, output) ->
        console.log 'output code: '+code
        console.log 'git output: '+output

        if (code == 0)
          output += '... Done!'

        Repos.create(name, desc, path, req.session.email)

        output += " Exit Code: #{code}"

        res.end tmpl({title: @title, content: output})
      ).bind @
    catch ex
      tmpl = @template(req, res)
      res.end tmpl({title: @title, content: ex.message})

module.exports = (Coffeegit, server, app) ->
  return new Git(Coffeegit, server, app)

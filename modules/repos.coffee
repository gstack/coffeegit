# Requires
Handlebars = require 'handlebars'
webutils = require './webutils'
_ = require 'lodash'
fs = require 'fs'
path = rpath = require 'path'
util = require 'util'
extend = require 'extend'
db = require './db'

# path of the users.json (will be created if not exists)
repos_json = rpath.join(__dirname, '..', 'db', 'repos.json')
repos_tmpl = rpath.join(__dirname, '..', 'db', 'cgitrepos.tmpl')
repos_dir = global.cgConfig.Git.repoDir+''

if !fs.existsSync(repos_json)
  fs.writeFileSync repos_json, JSON.stringify([])
  console.log "created repos.json @ #{repos_json}"

Repos = {

  rewrite: (cb) ->
    db.getRepos (repos) ->
      text = ""
      for re, i in repos
        re.name = re.name or re.repo
        repo = """
        repo.url=#{re.name}
        repo.path=#{re.path}
        repo.desc=#{re.desc}
        repo.owner=#{re.email}
        """

        text += repo + "\n\n"

      tmpl = fs.readFileSync(rpath.join(__dirname, '..', 'db', 'cgitrepos.tmpl')).toString()
      tmpl = tmpl.replace('#add-repos', text)

      fs.writeFileSync(global.cgConfig.Git.cgitrepos, tmpl)
      cb()


  create: (name, desc, path, email) ->
    entry = { name: name, desc: desc, path: path, email: 'owner@thelab.sh' }
    entry.url = name
    db.addRepo entry, ->
      console.log "saved #{name} to sql db".green
      db.getRepos (repos) ->
        text = ""
        for re, i in repos
          re.name = re.name or re.repo
          repo = """
          repo.url=#{re.name}
          repo.path=#{re.path}
          repo.desc=#{re.desc}
          repo.owner=#{re.email}
          """

          text += repo + "\n\n"

        tmpl = fs.readFileSync(rpath.join(__dirname, '..', 'db', 'cgitrepos.tmpl')).toString()
        tmpl = tmpl.replace('#add-repos', text)

        fs.writeFileSync(global.cgConfig.Git.cgitrepos, tmpl)

  clone: (name, desc, path, url, email) ->
    entry = { name: name, desc: desc, path: path, url: url }
    db.addRepo entry, ->
      console.log "saved #{name} to sql db".green
      db.getRepos (repos) ->
        text = ""
        for re, i in repos
          re.name = re.name or re.repo
          repo = """
          repo.url=#{re.name}
          repo.path=#{re.path}
          repo.desc=#{re.desc}
          repo.owner=#{re.email}
          """
          text += repo + "\n\n"

        tmpl = fs.readFileSync(rpath.join(__dirname, '..', 'db', 'cgitrepos.tmpl')).toString()
        tmpl = tmpl.replace('#add-repos', text)
        fs.writeFileSync(global.cgConfig.Git.cgitrepos, tmpl)
}

module.exports = Repos

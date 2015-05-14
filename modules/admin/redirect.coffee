# Main redirect module
module.exports = (Coffeegit, server, app) ->

  # register the route
  app.get '/', (req, res) ->
    session = req.session

    if session.logged_in
      res.redirect('/cgit')
    else
      res.redirect('/login')

  app.get '/scm.cgi', (req, res) ->
    session = req.session

    if session.logged_in
      res.redirect('/cgit')
    else
      res.redirect('/login')

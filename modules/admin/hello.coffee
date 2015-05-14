# Hello world module
module.exports = (Coffeegit, server, app) ->

  # register the route
  app.get '/hello', (req, res) ->
    res.json {
      hello: "world"
    }

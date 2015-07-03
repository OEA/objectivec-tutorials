routeController = module.exports
routeController.init = (app) ->
  app.get('/', (req, res) ->
    res.send(
      code:200
      message:"Index test"
    )
  )
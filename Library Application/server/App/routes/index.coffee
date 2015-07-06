ctrl = module.exports

user = require './api/v1/user'

ctrl.init = (app, db) ->
  user.init(app, db)


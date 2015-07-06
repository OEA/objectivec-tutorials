ctrl = module.exports
User = require '../../../Models/User'
ctrl.init = (app, db) ->
  app.post('/api/v1/user/add', (req, resp) ->

    name = req.body.name
    username = req.body.username
    email = req.body.email

    user = new User(name, email, username)

    db.collection "users", (err, collection) =>
      if err
        console.error err
      collection.insert user, (err, user) =>
        if err
          console.error err
      this

    resp.send(
      code: 200,
      message: "success",
      name: name,
      username: username,
      email: email
    )
  )
  app.get('/api/v1/user/:username', (req, resp) ->
    username = req.params.username
    if username.length > 3
      collection = db.collection "users"
      collection.find(
        categories: {
          $elemMatch: {
            username: username
          }
        },{'limit':20}
      ).toArray((err, users) ->
        resp.send(
          code:200
          message:"Sucesss",
          users:users
        )
      )
    else
      resp.send(
        code:404
        message:"Sucesss"
      )
  )



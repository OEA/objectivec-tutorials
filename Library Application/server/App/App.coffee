http = require "http"
express = require "express"
_cors = require "cors"

originList = ["http://www.oeaslan.com", "http://oeaslan.com", "http://localhost", "http://localhost:63342"]

corsOptions =
  origin : (origin, callback) ->
    originAllowed = originList.indexOf(origin) != -1
    callback(null,originAllowed)

app = express()
app.use(_cors(corsOptions))
routes = require "./Routes"
routes.init(app)
server = http.createServer(app)
server.listen(process.env.PORT || 8080)
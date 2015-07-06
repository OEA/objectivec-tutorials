http = require "http"
express = require "express"
_cors = require "cors"
bodyParser = require "body-parser"
mongodb = require("mongodb").MongoClient
app = express()

app.use(bodyParser.json())
app.use(bodyParser.urlencoded({
  extended: true
}))
app.use(bodyParser.text({ type: 'text/html' }))
api = require "./routes"


mongodb.connect('mongodb://localhost:27017/library', (err, db) ->
  if err
    throw err
  else
    api.init(app, db)
    console.log "Connected to Database"
)

originList = ["http://www.oeaslan.com", "http://oeaslan.com", "http://localhost", "http://localhost:63342"]

corsOptions =
  origin : (origin, callback) ->
    originAllowed = originList.indexOf(origin) != -1
    callback(null,originAllowed)


server = http.createServer(app)
server.listen(process.env.PORT || 8000)
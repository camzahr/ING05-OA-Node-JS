# Import a module
http = require 'http'
user = require './users.coffee'
metrics = require './metrics.coffee'
url = require 'url'
fs = require 'fs'
levelup = require 'level'
levelws = require 'level-ws'
bodyparser  = require 'body-parser'
db = levelws levelup "../db"
stylus = require 'stylus'
express = require 'express'

app = express()
# Declare an http server
app.set 'port', 1337

app.listen app.get('port'), () ->

  app.set 'views', __dirname + '/../view'
  app.use '/', express.static "#{__dirname}/../view/public"
  app.set 'view engine', 'pug'
  app.use bodyparser.json()
  app.use bodyparser.urlencoded({ extended: true })

  app.get '/', (req, res) ->
    res.render 'index', {}

  app.get '/metrics.json', (req, res) ->
    metrics.get (err, data) ->
      throw next err if err
      res.status(200).json data
  app.get '/save', (req, res) ->
    metrics.save 0, met, (err) ->
              throw err if err
              console.log 'Metrics saved'
  #user.get "Robin", (id) ->
  # Write a response header
  #res.writeHead 200,'Content-Type': 'text/plain'

  # Write a response content
  #res.end('Hello World\n');`
  #res.end "hello #{id}" # "hello" + id

  app.get '/hello/:name', (req, res) ->
    res.send "Hello #{req.params.name}"

console.log "server listening on #{app.get 'port'}"

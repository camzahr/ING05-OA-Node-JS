# Import a module
http = require 'http'
user = require './user'
url = require 'url'
fs = require 'fs'
express = require 'express'
levelup = require 'levelup'
levelws = require 'level-ws'
bodyparser = require 'body-parser'
metrics = require './metrics'

db = levelws levelup "#{__dirname}/../db"

app = express()
app.set 'port', 1337

app.listen app.get('port'), () ->
console.log "server listening on #{app.get 'port'}"

#app.get '/', (req, res) ->
# GET
#app.post '/', (req, res) ->
# POST
#app.put '/', (req, res) ->
# PUT
#app.delete '/', (req, res) ->
# DELETE

app.set 'views',"#{__dirname}/../views"
app.set 'view engine','pug'

app.get '/', (req, res) ->
	res.render 'index', {}

app.use '/', express.static "#{__dirname}/../views/public"
app.use bodyparser.json()
app.use bodyparser.urlencoded()

app.get '/metrics.json', (req, res) ->
	metrics.get (err, data) ->
		throw next err if err
		res.status(200).json data


#db.put key, value, (err) ->
#	if err then …

#db.get key, (err, value) ->
#	if err then …

db.put('key 1', 'value 1')  
db.put('key 2', 'value 2')  

db.get 'key 1', (err, value) ->
  if err then return handleError(err)

  else console.log('value:', value)


# Declare an http server
#http.createServer (req, res) ->

 # path = url.parse(req.url).pathname

  #user.get "jeremy", (id) ->
    # Write a response header
   # res.writeHead 200,
    #  'Content-Type': 'text/plain'

    # Write a response content
    #res.end('Hello World\n');`
    #res.end "hello #{id}" # "hello" + id



# Start the server
app.listen 1337, '127.0.0.1', () ->
  console.log "running on 127.0.0.1:1337"
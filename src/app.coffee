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

##
morgan = require('morgan') ('dev')
cookieParser = require 'cookie-parser'
errorhandler = require 'errorhandler'
methodOverride = require 'method-override'

db = levelws levelup "#{__dirname}/../db/user"

stream = db.createReadStream() 
stream = db.createWriteStream()

##
session = require 'express-session'
LevelStore = require('level-session-store')(session)

server = require('http').Server(app)
io = require('socket.io')(server)

app = express()


if process.env.NODE_ENV == 'development'
  #only use in development
  app.use(errorhandler())

app.use morgan
#app.use morgan

app.set 'port', 1337

io.on 'connection', (socket) ->
  sockets.push socket

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



met = [
  timestamp:(new Date '2013-11-04 14:00 UTC').getTime(), value:12, 
  timestamp:(new Date '2013-11-04 14:10 UTC').getTime(), value:13  ]
  
#metrics.save 0, met, (err) ->  
 # throw err  if err 
  #console.log 'Metrics saved'

app.set 'views',"#{__dirname}/../views"
app.set 'view engine','pug'



app.use '/', express.static "#{__dirname}/../views/public"
app.use bodyparser.json()
app.use bodyparser.urlencoded()
##
app.use cookieParser()

#override with the X-HTTP-Method-Override header in the request
app.use methodOverride 'X-HTTP-Method-Override'

app.get '/metrics.json', (req, res) ->
	metrics.get (err, data) ->
		throw next err if err
		res.status(200).json data

db.put('key1', 'value1')

app.get '/get/:num', (req, res) ->
	res.setHeader('Content-Type', 'text/plain')
	db.get req.params.num, (err, value) ->
	  res.end('value:' + value)
	  

#db.put key, value, (err) ->
#	if err then …

#db.get key, (err, value) ->
#	if err then …

db.put('key 1', 'value 1')  
db.put('key 2', 'value 2')  

db.get 'key1', (err, value) ->
  if err then return handleError(err)

  else console.log('value:', value)

db.del('key 2');  

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

sockets = []

io.on 'connection', (socket) ->
  sockets.push socket

#configuration of session db
app.use session
  secret: 'MyAppSecret'
  store: new LevelStore './db/sessions'
  resave: true
  saveUninitialized: true

app.use (req,res,next) ->
  if req.session.loggedIn == true
    req.session.count++
    req.session.history ?= [] #creates [] if history is undefined
    req.session.history.push req.url
  for s in sockets
    s.emit 'log',
      url: req.url,
      username: req.session.username || 'anonymous'
  next()



authCheck = (req, res, next) ->
  console.log('log : ', req.session.loggedIn)
  unless req.session.loggedIn == true
    res.redirect '/login'
  else
    next()

#add routes defined in other files
app.use require('./routes/auth.coffee')
app.use require('./routes/user.coffee')
app.use require('./routes/user-metrics.coffee')


# Start the server
app.listen 1337, '127.0.0.1', () ->
  console.log "running on 127.0.0.1:1337"
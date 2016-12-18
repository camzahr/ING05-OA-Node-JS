user = require "../user"
express = require "express"
router = express.Router()

router.post '/signup', (req, res) ->
  user.save req.body.username, req.body.password, req.body.name,
  req.body.email, (err, value) ->
    if err
      res.redirect('/signup')
    else
      res.redirect("/hello/" + req.body.username)

router.get '/signup', (req, res) ->
  res.render 'signup'

router.get '/login', (req, res) ->
  res.render 'login'

router.post '/login', (req, res) ->
  user.get req.body.username, (err, data) ->
    res.redirect '/login' if err
    if data.pwd != req.body.password
      res.redirect '/login'
    else if !data.username
      res.redirect '/login'
    else
      req.session.loggedIn = true
      req.session.username = data.username
      res.redirect("/hello/" + req.body.username)

router.get '/logging', (req, res) ->
  res.render 'logging'

router.get '/logout', (req, res) ->
  req.session.loggedIn = false
  delete req.session.username
  delete req.session.count
  delete req.session.history
  res.redirect '/login'

module.exports = router
user = require "../user"
metrics = require '../metrics'
userMetric = require '../user-metric'
express = require "express"
router = express.Router()

authCheck = (req, res, next) ->
  console.log('log : ', req.session.loggedIn)
  unless req.session.loggedIn == true
    res.redirect '/login'
  else
    next()

router.get "/", (req, res) ->
  if !req.session
    res.redirect "/login"
  else
    res.redirect '/hello/' + req.session.username

router.get "/history", (req, res) ->
  res.json req.session.history

router.get '/user/:username', (req, res) ->
  user.get req.params.username, (err, value) ->
    if err
      res.status(404).send(err)
    else
      res.status(200).json value

router.delete '/user/:username', (req,res) ->
  user.remove req.params.username, (err) ->
    if err
      res.status(404).send(err)
    else
      res.status(200).send()

router.get "/hello/:name",authCheck, (req, res) ->
  res.render 'hello',
    name: req.params.name

module.exports = router
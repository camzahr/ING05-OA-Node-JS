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

router.get "/hello/:name",authCheck, (req, res) ->
  res.render 'hello',
    name: req.params.name

module.exports = router
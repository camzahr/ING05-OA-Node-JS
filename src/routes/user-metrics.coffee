user = require "../user"
metrics = require '../metrics'
userMetric = require '../user-metric'
express = require "express"
router = express.Router()

router.get "/", (req, res) ->
  if !req.session
    res.redirect "/login"
  else
    res.redirect '/hello/' + req.session.username

router.get "/user-metric", (req,res) ->
  userMetric.get req.session.username, (err, metricsId) ->
    if err
      res.status(404).send(err)
    else
      res.status(200).json metricsId

router.post "/user-metric", (req, res) ->
  met = [timestamp:(new Date '2013-11-04 14:00 UTC').getTime(), value:12, 
  timestamp:(new Date '2013-11-04 14:10 UTC').getTime(), value:13]

  userMetric.save req.session.username, met, (err)->
    if err
      res.status(404).send(err)
    else
      res.status(200).send()
      res.redirect("/")

router.delete "/user-metric/:id", (req,res) ->
  userMetric.remove req.session.username, req.params.id, (err) ->
    if err
      res.status(404).send(err)
    else
      res.status(200).send()

module.exports = router
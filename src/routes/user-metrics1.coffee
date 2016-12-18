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

router.get "/metrics(/:id)?", (req, res) ->
  #console.log(req)
  metrics.get req.params.id, (err, value) ->
    res.status(404).send(err) if err
    userMetric.get req.session.username, (err, metricsId) ->
      console.log metricsId
      selected = []
      #select only values that user has access to
      for val in value
        if metricsId.indexOf(val.id) isnt -1
          selected.push(val)
      if err
        res.status(404).send(err)
      else
        #sorting by timestamp in order to display well
        selected.sort (a,b) ->
          if (a.timestamp < b.timestamp) then -1
          else 1
        # Group by batch id
        # output desired: {id: [{timestamp, value}]}
        output = {}
        selected.map (e) ->
          if output.hasOwnProperty(e.id)
            output[e.id].push
              timestamp: e.timestamp
              value: e.value
          else
            output[e.id] = []
            output[e.id].push
              timestamp: e.timestamp
              value: e.value
        res.status(200).json output

router.post "/metrics/:id", (req, res) ->
  metrics.put req.params.id, req.body, (err) ->
  if err
    res.status(404).send(err)
  else
    res.status(200).send()

router.delete "/metrics/:id", (req,res) ->
  userMetric.get req.session.username, (err, metricsId) ->

    if err then res.status(404).send()

    if metricsId.indexOf(req.params.id) isnt -1
      metrics.remove req.params.id, (err) ->
        if err
          res.status(404).send(err)
        else
          res.status(200).send()
    else
      res.status(401).send()

router.get "/user-metric", (req,res) ->
  userMetric.get req.session.username, (err, metricsId) ->
    if err
      res.status(404).send(err)
    else
      res.status(200).json metricsId

router.post "/user-metric", (req, res) ->
  userMetric.save req.session.username, req.body, (err)->
  if err
    res.status(404).send(err)
  else
    res.status(200).send()

router.delete "/user-metric/:id", (req,res) ->
  userMetric.remove req.session.username, req.params.id, (err) ->
    if err
      res.status(404).send(err)
    else
      res.status(200).send()

module.exports = router
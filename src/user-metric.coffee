db = require('./db')("#{__dirname}/../db/user-metric")

module.exports =
  ###
    get(username, callback)
    ------------------------
    get all metrics id associated to the user

    username: user's pseudo (used to login)
    callback: callback function

    key : user-metric:username:metricId
  ###
  get: (username, callback) ->
    metricsId = []

    rs = db.createReadStream()

    rs.on 'data', (data) ->
      [_, _username, _userMetricId] = data.key.split ':'
      if data.value and _username is username
        metricsId.push _userMetricId
    rs.on 'error', callback
    rs.on 'close', ->
      callback null, metricsId
  ###
    save(username, mectricsId, callback)
    ------------------------------------
    link one or several metrics id to a user

    username: user's pseudo (used to login)
    metricsId: a list of metrics to add to the user
    callback: callback function
  ###
  save: (username, metricsId, callback) ->
    if !metricsId.length
      callback 'not an array'

    ws = db.createWriteStream()

    ws.on 'error', callback
    ws.on 'close', callback

    for metricId in metricsId
      ws.write
        key: "user-metric:#{username}:#{metricId}"
        value: true
    ws.end()
  ###
    remove(username, metricId, callback)
    -----------------------------------
    remove the link between metric and user

    username: user's pseudo (used to login)
    metricId: metric's id
    callback: callback function
  ###
  remove: (username, metricId, callback) ->
    db.del "user-metric:#{username}:#{metricId}" , (err) ->
      callback(err)
db = require('./db')("#{__dirname}/../db/metrics")

module.exports =

  put: (id, metrics, callback) ->
    #check that we have an array of metrics
    if !metrics.length
      callback("not an array")
    
    ws = db.createWriteStream()

    ws.on 'error', callback
    ws.on 'close', callback

    for m in metrics
      {timestamp, value} = m
      ws.write
        key: "metric:#{id}:#{timestamp}"
        value: value
    ws.end()

  get: (id, callback) ->
    metrics = []

    rs = db.createReadStream()

    rs.on 'data', (data) ->
      [_, _id, timestamp] = data.key.split ':'
      if id and id == _id
        metrics.push
          id: _id
          timestamp: timestamp
          value: data.value

    rs.on 'error', callback
    rs.on 'close', ->
      callback null, metrics
  
  remove: (id, callback) ->
    this.get id, (err, metrics) ->
      if !metrics.length
        callback false
        return
      
      toDel = []
      for m in metrics
        key = "metric:#{m.id}:#{m.timestamp}"
        toDel.push {type: 'del', key: key}
      db.batch toDel, (err) ->
        callback err
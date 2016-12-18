db = require('./db')("#{__dirname}/../db/metrics")

module.exports =
	get: (callback) ->  
		callback null, [timestamp:(new Date '2013-11-14 14:00 UTC').getTime(), value:1] , [timestamp:(new Date '2013-11-04 14:30 UTC').getTime(), value:2]
	
	post: (callback) ->


		
	save: (id, metrics, callback) ->
		ws = db.createWriteStream()
		ws.on 'error', callback
		ws.on 'close', callback
		for metric in metrics
			{timestamp, value} = metric
			ws.write key: "metric:#{id}:#{timestamp}", value: value
		ws.end()
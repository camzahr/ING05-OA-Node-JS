
module.exports =
  #get: (user, callback) ->
    #return callback user

  #save: (id, callback) ->
    #return callback(id)


get: (callback) -> 
    	callback null, [
    		timestamp:(new Date '2013-11-04 14:00 UTC').getTime(), value:12
    	,
    		timestamp:(new Date '2013-11-04 14:30 UTC').getTime(), value:15
    	]
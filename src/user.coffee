db = require('./db')("#{__dirname}/../db/user")

module.exports =

  get: (username, callback) ->
    user = {}
    rs = db.createReadStream()

    rs.on 'data', (data) ->
      [_, _username] = data.key.split ':'
      [_name, _pwd, _email] = data.value.split ':'
      if _username == username
        user =
          username: _username
          pwd: _pwd
          email: _email
          name: _name
    rs.on 'error', callback
    rs.on 'close', ->
      callback null, user

  save: (username, pwd, name, email, callback) ->
    ws = db.createWriteStream()

    ws.on 'error', callback
    ws.on 'close', callback

    ws.write
      key: "user:#{username}"
      value: "#{name}:#{pwd}:#{email}"
    ws.end()

  remove: (username, callback) ->
    toDel = [{type: 'del', key: "user:#{username}"}]
    db.batch toDel, (err) ->
      callback err
// Generated by CoffeeScript 1.11.1
var db;

db = require('./db')(__dirname + "/../db/user");

module.exports = {
  get: function(username, callback) {
    var rs, user;
    user = {};
    rs = db.createReadStream();
    rs.on('data', function(data) {
      var _, _email, _name, _pwd, _username, ref, ref1;
      ref = data.key.split(':'), _ = ref[0], _username = ref[1];
      ref1 = data.value.split(':'), _name = ref1[0], _pwd = ref1[1], _email = ref1[2];
      if (_username === username) {
        return user = {
          username: _username,
          pwd: _pwd,
          email: _email,
          name: _name
        };
      }
    });
    rs.on('error', callback);
    return rs.on('close', function() {
      return callback(null, user);
    });
  },
  save: function(username, pwd, name, email, callback) {
    var ws;
    ws = db.createWriteStream();
    ws.on('error', callback);
    ws.on('close', callback);
    ws.write({
      key: "user:" + username,
      value: name + ":" + pwd + ":" + email
    });
    return ws.end();
  },
  remove: function(username, callback) {
    var toDel;
    toDel = [
      {
        type: 'del',
        key: "user:" + username
      }
    ];
    return db.batch(toDel, function(err) {
      return callback(err);
    });
  }
};

// Generated by CoffeeScript 1.11.1
var db;

db = require('./db')(__dirname + "/../db/metrics");

module.exports = {

  /*
    `put(id, metrics, callback)`
    -----------
    add one or several metrics associated with id
    
    `id`: id of the metrics to add
    `metrics`: array containing the metrics to save
    `callback`: callback function
  
    key : metric:id:timestamp
   */
  put: function(id, metrics, callback) {
    var i, len, m, timestamp, value, ws;
    if (!metrics.length) {
      callback("not an array");
    }
    ws = db.createWriteStream();
    ws.on('error', callback);
    ws.on('close', callback);
    for (i = 0, len = metrics.length; i < len; i++) {
      m = metrics[i];
      timestamp = m.timestamp, value = m.value;
      ws.write({
        key: "metric:" + id + ":" + timestamp,
        value: value
      });
    }
    return ws.end();
  },

  /*
    `get(id, callback)`
    -----------
    return metrics associated to the id
    
    `id`: id of the metrics
    `callback`: callback function
  
    key : metric:id:timestamp
   */
  get: function(id, callback) {
    var metrics, rs;
    metrics = [];
    rs = db.createReadStream();
    rs.on('data', function(data) {
      var _, _id, ref, timestamp;
      ref = data.key.split(':'), _ = ref[0], _id = ref[1], timestamp = ref[2];
      if (id && id === _id) {
        return metrics.push({
          id: _id,
          timestamp: timestamp,
          value: data.value
        });
      }
    });
    rs.on('error', callback);
    return rs.on('close', function() {
      return callback(null, metrics);
    });
  },

  /*
    `remove(id, callback)`
    -----------
    remove metrics associated to the id
    
    `id`: id of the metrics
    `callback`: callback function
   */
  remove: function(id, callback) {
    return this.get(id, function(err, metrics) {
      var i, key, len, m, toDel;
      if (!metrics.length) {
        callback(false);
        return;
      }
      toDel = [];
      for (i = 0, len = metrics.length; i < len; i++) {
        m = metrics[i];
        key = "metric:" + m.id + ":" + m.timestamp;
        toDel.push({
          type: 'del',
          key: key
        });
      }
      return db.batch(toDel, function(err) {
        return callback(err);
      });
    });
  }
};

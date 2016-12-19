// Generated by CoffeeScript 1.11.1
var express, metrics, router, user, userMetric;

user = require("../user");

metrics = require('../metrics');

userMetric = require('../user-metric');

express = require("express");

router = express.Router();

router.get("/", function(req, res) {
  if (!req.session) {
    return res.redirect("/login");
  } else {
    return res.redirect('/hello/' + req.session.username);
  }
});

router.get("/metrics(/:id)?", function(req, res) {
  return metrics.get(req.params.id, function(err, value) {
    if (err) {
      res.status(404).send(err);
    }
    return userMetric.get(req.session.username, function(err, metricsId) {
      var i, len, output, selected, val;
      console.log(metricsId);
      selected = [];
      for (i = 0, len = value.length; i < len; i++) {
        val = value[i];
        if (metricsId.indexOf(val.id) !== -1) {
          selected.push(val);
        }
      }
      if (err) {
        return res.status(404).send(err);
      } else {
        selected.sort(function(a, b) {
          if (a.timestamp < b.timestamp) {
            return -1;
          } else {
            return 1;
          }
        });
        output = {};
        selected.map(function(e) {
          if (output.hasOwnProperty(e.id)) {
            return output[e.id].push({
              timestamp: e.timestamp,
              value: e.value
            });
          } else {
            output[e.id] = [];
            return output[e.id].push({
              timestamp: e.timestamp,
              value: e.value
            });
          }
        });
        return res.status(200).json(output);
      }
    });
  });
});

router.post("/metrics/:id", function(req, res) {
  return metrics.put(req.params.id, req.body, function(err) {
    if (err) {
      return res.status(404).send(err);
    } else {
      return res.status(200).send();
    }
  });
});

router["delete"]("/metrics/:id", function(req, res) {
  return userMetric.get(req.session.username, function(err, metricsId) {
    if (err) {
      res.status(404).send();
    }
    if (metricsId.indexOf(req.params.id) !== -1) {
      return metrics.remove(req.params.id, function(err) {
        if (err) {
          return res.status(404).send(err);
        } else {
          return res.status(200).send();
        }
      });
    } else {
      return res.status(401).send();
    }
  });
});

router.get("/user-metric", function(req, res) {
  return userMetric.get(req.session.username, function(err, metricsId) {
    if (err) {
      return res.status(404).send(err);
    } else {
      return res.status(200).json(metricsId);
    }
  });
});

router.post("/user-metric", function(req, res) {
  return userMetric.save(req.session.username, req.body, function(err) {
    if (err) {
      return res.status(404).send(err);
    } else {
      return res.status(200).send();
    }
  });
});

router["delete"]("/user-metric/:id", function(req, res) {
  return userMetric.remove(req.session.username, req.params.id, function(err) {
    if (err) {
      return res.status(404).send(err);
    } else {
      return res.status(200).send();
    }
  });
});

module.exports = router;

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
  var met;
  met = [
    {
      timestamp: (new Date('2013-11-04 14:00 UTC')).getTime(),
      value: 12,
      timestamp: (new Date('2013-11-04 14:10 UTC')).getTime(),
      value: 13
    }
  ];
  return userMetric.save(req.session.username, met, function(err) {
    if (err) {
      return res.status(404).send(err);
    } else {
      res.status(200).send();
      return res.redirect("/");
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

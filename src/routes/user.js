// Generated by CoffeeScript 1.11.1
var authCheck, express, metrics, router, user, userMetric;

user = require("../user");

metrics = require('../metrics');

userMetric = require('../user-metric');

express = require("express");

router = express.Router();

authCheck = function(req, res, next) {
  console.log('log : ', req.session.loggedIn);
  if (req.session.loggedIn !== true) {
    return res.redirect('/login');
  } else {
    return next();
  }
};

router.get("/", function(req, res) {
  if (!req.session) {
    return res.redirect("/login");
  } else {
    return res.redirect('/hello/' + req.session.username);
  }
});

router.get("/hello/:name", authCheck, function(req, res) {
  return res.render('hello', {
    name: req.params.name
  });
});

module.exports = router;

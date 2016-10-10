//import a module
var http = require('http');
var users = require('./user.js');
//Declare an http server
http.createServer(function(req, res){
  users.get("Jeremy", function(id){
    //Write a response header
    res.writeHead(200, {'Content-Type': 'text/plain'});
    //Write a response content
    res.end('Hello ' + id);
  });
  // Start the server
}).listen(1337, '127.0.0.1');

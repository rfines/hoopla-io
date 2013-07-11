routingService = require './services/routingService'
mongoService = require './services/mongoService'
eventController = require './controllers/eventController'
userController = require './controllers/userController'
console.log(userController)

CONFIG = require('config')

server = require("restify").createServer(name: "ruckus.io-api")
server.listen process.env.PORT || CONFIG.port

routes = [
  ['get', '/event/:id', eventController]
  ['get', '/event/:id/secret', eventController, {handler: 'getSecret'}]
  ['post', '/user', userController]
  ['del', '/user/:id', userController]
]

routingService.init server, routes

mongoService.init()
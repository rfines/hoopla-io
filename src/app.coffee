routingService = require './services/routingService'
mongoService = require './services/mongoService'
eventController = require './controllers/eventController'
CONFIG = require('config')

server = require("restify").createServer(name: "ruckus.io-api")
server.listen process.env.PORT || CONFIG.port

routes = [
  ['get', '/event/:id', eventController]
  ['get', '/event/:id/secret', eventController, {handler: 'getSecret'}]
]

routingService.init server, routes

mongoService.init()
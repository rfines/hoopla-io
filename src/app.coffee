routingService = require './services/routingService'
mongoService = require './services/mongoService'
eventController = require './controllers/eventController'
userController = require './controllers/userController'
businessController = require './controllers/businessController'

CONFIG = require('config')

restify = require("restify")
server = restify.createServer(name: "ruckus.io-api")
server.use(restify.queryParser())
server.listen process.env.PORT || CONFIG.port

routes = [
  ['get', '/event/:id', eventController]
  ['get', '/event/:id/secret', eventController, {handler: 'getSecret'}]
  ['post', '/user', userController]
  ['del', '/user/:id', userController]
  ['get', '/business', businessController, {handler : 'search'}]
  ['get', '/business/:id', businessController]
]

routingService.init server, routes

mongoService.init()
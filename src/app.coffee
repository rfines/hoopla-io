routingService = require './services/routingService'
mongoService = require './services/mongoService'
eventController = require './controllers/eventController'
userController = require './controllers/userController'
businessController = require './controllers/businessController'

CONFIG = require('config')

restify = require("restify")
server = restify.createServer(name: "ruckus.io-api")
server.use(restify.queryParser())
server.use(restify.bodyParser({ mapParams: false }));
server.listen process.env.PORT || CONFIG.port

routes = [
  ['get', '/event/:id', eventController]
  ['post', '/user', userController]
  ['del', '/user/:id', userController]
  ['get', '/business', businessController, {handler : 'search'}]
  ['get', '/business/:id', businessController]
  ['del', '/business/:id', businessController]
  ['put', '/business/:id', businessController]
  ['post', '/business', businessController]
]

routingService.init server, routes

mongoService.init()
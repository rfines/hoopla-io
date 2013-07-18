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
  ['post', '/user', userController]
  ['del', '/user/:id', userController]
]

scaffold = (resource, controller) ->
  routes.push ['get', "/#{resource}", controller, {handler : 'search'}]
  routes.push ['get', "/#{resource}/:id", controller]
  routes.push ['del', "/#{resource}/:id", controller]
  routes.push ['put', "/#{resource}/:id", controller]
  routes.push ['post', "/#{resource}", controller]

scaffold('business', businessController)
scaffold('event', eventController)

routingService.init server, routes

mongoService.init()
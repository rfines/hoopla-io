CONFIG = require('config')
restify = require("restify")
routingService = require './routingService'
authorizationService = require './authorizationService'
eventController = require '../controllers/eventController'
userController = require '../controllers/userController'
businessController = require '../controllers/businessController'

build = ->
  server = restify.createServer(name: "ruckus.io-api")
  server.use(restify.CORS());
  server.use(restify.fullResponse());
  server.use(restify.authorizationParser());
  server.use(restify.bodyParser({ mapParams: false }));
  server.use(restify.queryParser())
  server.listen process.env.PORT || CONFIG.port

  server.use (req, res, next) =>
    authorizationService.authorize req.authorization, ( =>
      return next()
    ), (message) =>
      return next new restify.NotAuthorizedError(message)

  routes = []

  scaffold = (resource, controller) ->
    routes.push ['get', "/#{resource}", controller, {handler : 'search'}]
    routes.push ['get', "/#{resource}/:id", controller]
    routes.push ['del', "/#{resource}/:id", controller]
    routes.push ['put', "/#{resource}/:id", controller]
    routes.push ['post', "/#{resource}", controller]

  scaffold('business', businessController)
  scaffold('event', eventController)
  scaffold('user', userController)

  routingService.init server, routes
  return server

module.exports =
  build : build
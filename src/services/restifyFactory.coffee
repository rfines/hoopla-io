CONFIG = require('config')
restify = require("restify")
routingService = require './routingService'
eventController = require '../controllers/eventController'
userController = require '../controllers/userController'
businessController = require '../controllers/businessController'
authTokenController = require '../controllers/authTokenController'
devController = require '../controllers/devController'
restifyPlugins = require '../plugins/restifyPlugins'


build = ->
  server = restify.createServer(name: "hoopla-io-api")
  server.use restify.CORS()
  server.use restify.fullResponse()
  server.use restify.authorizationParser()
  server.use restify.bodyParser({ mapParams: false })
  server.use restify.queryParser()
  server.use restifyPlugins.AuthorizationParser
  server.use restifyPlugins.AuthTokenParser
  server.use restifyPlugins.NearParamParser

  server.listen process.env.PORT || CONFIG.port

  routes = [
    ['post', "/tokenRequest", authTokenController, {handler : 'createToken'}]
    ['get', '/dev/indexAll', devController, {handler : 'indexAll'}]
    ['get', '/dev/buildAllSchedules', devController, {handler : 'buildAllSchedules'}]
  ]

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
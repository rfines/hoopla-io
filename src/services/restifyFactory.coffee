CONFIG = require('config')
restify = require("restify")
routingService = require './routingService'
eventController = require '../controllers/eventController'
userController = require '../controllers/userController'
businessController = require '../controllers/businessController'
authTokenController = require '../controllers/authTokenController'
devController = require '../controllers/devController'
passwordResetController = require '../controllers/passwordResetController'
restifyPlugins = require '../plugins/restifyPlugins'
legacyRouteController = require '../controllers/legacyRouteController'

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
    ['post', '/passwordReset/emailRequest', passwordResetController, {handler : 'requestResetEmail'}]
    ['post', '/passwordReset', passwordResetController, {handler : 'resetPassword'}]
    ['post', "/tokenRequest", authTokenController, {handler : 'createToken'}]
    ['get', '/dev/indexAll', devController, {handler : 'indexAll'}]
    ['get', '/dev/buildAllSchedules', devController, {handler : 'buildAllSchedules'}]
    ['get', '/dev/bcryptPassword', devController, {handler:'bcryptPassword'}]
    ['get', '/api/getevents', legacyRouteController, {handler: 'search'}]
    ['get', '/api/getevent', legacyRouteController, {handler:'search'}]
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
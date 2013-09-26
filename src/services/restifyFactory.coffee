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
feedController = require '../controllers/feedController'
widgetController = require '../controllers/widgetController'
promotionTargetController = require '../controllers/promotionTargetController'
promotionRequestController = require '../controllers/promotionRequestController'
mediaController = require '../controllers/mediaController'
eventTagController = require '../controllers/eventTagController'

build = ->
  server = restify.createServer(name: "hoopla-io-api")
  server.use restify.CORS()
  server.use restify.fullResponse()
  server.use restify.authorizationParser()
  server.use restify.gzipResponse()
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
    ['get', '/legacy/getevents', legacyRouteController, {handler: 'search'}]
    ['get', '/legacy/getevent', legacyRouteController, {handler:'get'}]
    ['get', '/business/:id/events', businessController, {handler:'getEvents'}]
    ['get', '/feed/:id/results', feedController, {handler: 'getResults'}]
    ['get', '/widget/:id/results', widgetController, {handler: 'getResults'}]
    ['get', '/user/:id/businesses', userController, {handler:'businesses'}]
    ['get', '/user/:id/events', userController, {handler:'events'}]
    ['put', '/user/:id/password', userController, {handler:'password'}]
    ['post', '/media', mediaController, {handler:'uploads'}]
    ['get', '/user/:id/media', mediaController, {handler:'media'}]
    ['get', '/user/:id/widgets', widgetController, {handler:'getForUser'}]
    ['post', '/business/:id/promotionTarget', businessController, {handler: 'addPromotionTarget'}]
    ['post', '/event/:id/promotionRequest', eventController, {handler:'addPromotionRequest'}]
    ['get', '/venues', businessController, {handler: 'allVenues'}]
    ['get','/event/:id/invite.ics',eventController, {handler:'getICalFile'}]
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
  scaffold('feed', feedController)
  scaffold('widget', widgetController)
  scaffold('media', mediaController)
  scaffold('promotionTarget', promotionTargetController)
  scaffold('promotionRequest', promotionRequestController)
  scaffold('eventTag', eventTagController)

  routingService.init server, routes
  return server

module.exports =
  build : build
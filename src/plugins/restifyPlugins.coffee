authorizationService = require '../services/authorizationService'
restify = require 'restify'
userService = require '../services/data/userService'

module.exports.AuthorizationParser = (req, res, next) =>
  authorizationService.authorize req.authorization, ( =>
    return next()
  ), (message) =>
    return next new restify.NotAuthorizedError(message)

module.exports.AuthTokenParser = (req, res, next) =>
  if req.authorization.basic.username and req.headers['x-authtoken']
    userService.getByAppToken req.authorization.basic.username, req.headers['x-authtoken'], (err, user) ->
      req.authUser = user
      next()
  else
    next()    
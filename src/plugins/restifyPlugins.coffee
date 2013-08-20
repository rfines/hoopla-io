authorizationService = require '../services/authorizationService'
restify = require 'restify'
userService = require '../services/data/userService'
postalCodeService = require('../services/postalCodeService')
geoCoder = require('../services/geocodingService')

module.exports.AuthorizationParser = (req, res, next) =>
  authorizationService.authorize req, ( =>
    return next()
  ), (message) =>
    return next new restify.NotAuthorizedError(message)

module.exports.AuthTokenParser = (req, res, next) =>
  if req.authorization?.basic?.username and req.headers['x-authtoken']
    userService.getByAppToken req.authorization.basic.username, req.headers['x-authtoken'], (err, user) ->
      req.authUser = user
      next()
  else
    next()    

module.exports.NearParamParser = (req, res, next) =>
  postalCodeService = req.postalCodeService || postalCodeService
  geoCoder = req.geoCoder || geoCoder
  if req.params.near
    if /^\d+$/.test(req.params.near)
      postalCodeService.get req.params.near, (err, doc) ->
        req.params.ll = "#{doc.geo.coordinates[0]},#{doc.geo.coordinates[1]}"
        req.params.near = undefined
        next()
    else
      geoCoder.geocodeAddress req.params.near, (err, result) ->
        if err
          cb err, null
        else
          req.params.ll = "#{result.longitude},#{result.latitude}"
          req.params.near = undefined
          next()
  else
    next()
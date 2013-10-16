mongoose = require 'mongoose'
restify = require 'restify'
_ = require 'lodash'

class AuthTokenController
  model : require('hoopla-io-core').User
  bcryptService : require('../services/bcryptService')
  sha1Service : require '../services/sha1Service'
  tokenService : require '../services/tokenService'
  
  constructor : (@name) ->

  createToken: (req, res, next) =>
    body = req.body
    if not (body?.email and body?.password)
      next new restify.NotAuthorizedError("Username or password is invalid")
    else
      @model.findOne {email: body.email}, (err, doc) =>
        if not doc
          next new restify.NotAuthorizedError("Username or password is invalid")
        else
          onFail = ->
            next new restify.NotAuthorizedError("Username or password is invalid")
          if doc.encryptionMethod is 'BCRYPT'
            onPass = =>
              match = _.find doc.authTokens, (item)=>
                return item.apiKey is req.authorization.basic.username
              if match?.authToken
                res.send 200, {authToken: match.authToken, user : doc._id}
              else
                token = "#{@tokenService.generateWithTimestamp(12)}"
                @updateToken(doc, req.authorization.basic.username, token)
                res.send 200, {authToken : token, user : doc._id}
              next()  
            @bcryptService.check body.password, doc.password, onPass, onFail
          else
            onPass = =>
              token = "#{@tokenService.generateWithTimestamp(12)}"
              @updateToken(doc, req.authorization.basic.username, token)
              @upgradeEncryption(doc, body.password)
              res.send 200, {authToken : token, user : doc._id}
              next()
            @sha1Service.check body.password, doc.password, onPass, onFail

  updateToken: (user, apiKey, token) ->
    user.update { $push : {authTokens: {apiKey : apiKey, authToken: token}}}, (err) ->
      console.log err if err

  upgradeEncryption: (user, password) ->
    @bcryptService.encrypt password, (encrypted) ->
      user.update { $set : {password: encrypted, encryptionMethod: 'BCRYPT'}}, {}, (err) ->
        console.log err if err

module.exports =  new AuthTokenController()
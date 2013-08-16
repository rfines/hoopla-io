mongoose = require 'mongoose'
restify = require 'restify'

class AuthTokenController
  model : require('../models/user').User
  bcryptService : require('../services/bcryptService')
  sha1Service : require '../services/sha1Service'
  tokenService : require '../services/tokenService'
  
  constructor : (@name) ->

  createToken: (req, res, next) =>
    body = req.body
    console.log body
    if not (body?.email and body?.password)
      console.log body.email
      console.log body.password
      next new restify.NotAuthorizedError("Username or password is invalid")
    else
      @model.findOne {email: body.email}, (err, doc) =>
        if not doc
          console.log body.email
          console.log body.password
          next new restify.NotAuthorizedError("Username or password is invalid")
        else
          onFail = ->
            next new restify.NotAuthorizedError("Username or password is invalid")
          if doc.encryptionMethod is 'BCRYPT'
            onPass = =>
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
    console.log 'update the token'
    user.update { $pull : {authTokens : { 'apiKey' : apiKey}}}, (err) ->
      user.update { $push : {authTokens: {apiKey : apiKey, authToken: token}}}, (err) ->
        console.log err if err

  upgradeEncryption: (user, password) ->
    @bcryptService.encrypt password, (encrypted) ->
      user.update { $set : {password: encrypted, encryptionMethod: 'BCRYPT'}}, {}, (err) ->
        console.log err if err

module.exports =  new AuthTokenController()
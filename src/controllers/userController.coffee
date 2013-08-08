mongoose = require 'mongoose'
RestfulController = require('./restfulController')

class UserController extends RestfulController
  bcryptService : require('../services/bcryptService')
  model : require('../models/user').User
  getFields : { 'applications' : 0, 'password' : 0, 'encryptionMethod' : 0}

  security: 
    destroy : (authenticatedUser, targetUser) ->
      authenticatedUser?._id and authenticatedUser._id.equals(targetUser._id) 
    update : (authenticatedUser, targetUser) ->
      authenticatedUser and authenticatedUser._id is targetUser._id

  constructor : (@name) ->
    super(@name)
    @hooks.create.pre = (user, req, res, next, cb) =>
      @bcryptService.encrypt user.password, (encrypted) ->
        user.password = encrypted
        user.encryptionMethod = 'BCRYPT'
        cb()

module.exports =  new UserController()
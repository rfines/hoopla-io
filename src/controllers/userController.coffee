mongoose = require 'mongoose'
RestfulController = require('./restfulController')

class UserController extends RestfulController
  model : require('../models/user').User
  getFields : { 'applications' : 0, 'password' : 0, 'encryptionMethod' : 0}
  hooks : require('./hooks/userHooks.coffee')
  
  security: 
    destroy : (authenticatedUser, targetUser) ->
      authenticatedUser?._id and authenticatedUser._id.equals(targetUser._id) 
    update : (authenticatedUser, targetUser) ->
      authenticatedUser and authenticatedUser._id is targetUser._id
    create : () ->
      true

  constructor : (@name) ->
    super(@name)

module.exports =  new UserController()
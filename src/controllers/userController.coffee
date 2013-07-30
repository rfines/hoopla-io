mongoose = require 'mongoose'
RestfulController = require('./restfulController')

class UserController extends RestfulController
  model : require('../models/user').User
  getFields : { 'applications' : 0, 'password' : 0, 'encryptionMethod' : 0}
  
  constructor : (@name) ->
    super(@name)

module.exports =  new UserController()
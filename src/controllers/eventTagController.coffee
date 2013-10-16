RestfulController = require('./restfulController')
_ = require 'lodash'
mongoose = require('mongoose')
restify =require 'restify'
ObjectId = mongoose.Schema.ObjectId


class EventTagController extends RestfulController
  model : require('hoopla-io-core').EventTag
  getFields : { }
  hooks : require('./hooks/restfulHooks.coffee')

  security: 
    search: (authenticatedUser, targetUser) ->
      true
    get : (authenticatedUser, targetUser) ->
      true
    destroy : (authenticatedUser, targetUser) ->
      false
    update : (authenticatedUser, targetUser) ->
      false
    create : () ->
      false

  constructor : (@name) ->
    super(@name)

module.exports =  new EventTagController()
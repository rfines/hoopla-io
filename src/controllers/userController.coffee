RestfulController = require('./restfulController')
_ = require 'lodash'
mongoose = require('mongoose')
ObjectId = mongoose.Schema.ObjectId


class UserController extends RestfulController
  model : require('../models/user').User
  getFields : { }
  hooks : require('./hooks/userHooks.coffee')
  populate : ['businessPrivileges.business']
  businessModel : require('../models/business').Business

  security: 
    get : (authenticatedUser, targetUser) ->
      authenticatedUser?._id and authenticatedUser._id.equals(targetUser._id)   
    destroy : (authenticatedUser, targetUser) ->
      authenticatedUser?._id and authenticatedUser._id.equals(targetUser._id) 
    update : (authenticatedUser, targetUser) ->
      authenticatedUser and authenticatedUser._id is targetUser._id
    create : () ->
      true

  constructor : (@name) ->
    super(@name)

  search : (req, res, next) =>  
    return next new restify.ResourceNotFoundError()
  
  businesses: (req,res,next) =>
    if req.params.id
      @model.findById req.params.id, @getFields, {lean:true}, (err, data) =>
        if err
          console.log err
          res.send 400, err
          next()
        else
          if data
            privIds = _.pluck data?.businessPrivileges, "business" 
            @businessModel.find {_id:{$in:privIds}}, {}, {lean:true}, (error,busData)->
              if error
                console.log "Error"
                console.log error
                res.send 500, error
                next()
              else
                res.send 200, busData
                next()
          else
            res.send 400, "Missing required parameter"
            next()

    else
      res.send 400, "Missing required parameter"
      next()

module.exports =  new UserController()
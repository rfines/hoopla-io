_ = require 'lodash'
SearchableController = require('./searchableController')
securityConstraints = require('./helpers/securityConstraints')

class EventController  extends SearchableController
  model : require('../models/event').Event
  type: 'event'
  populate: ['media']
  hooks: require('./hooks/eventHooks')
  promoRequest : require('../models/promotionRequest').PromotionRequest
  
  security: 
    get : securityConstraints.anyone
    destroy : (authenticatedUser, event) ->
      ownerMatch = _.find authenticatedUser.businessPrivileges, (priv) ->
        return priv?.business?.equals(event.business)
      return not _.isUndefined(ownerMatch)      
    update : (authenticatedUser, event) ->
      ownerMatch = _.find authenticatedUser.businessPrivileges, (priv) ->
        return priv?.business?.equals(event.business)
      return not _.isUndefined(ownerMatch)  
    create : (authenticatedUser, event) ->
      ownerMatch = _.find authenticatedUser.businessPrivileges, (priv) ->
        return priv?.business?.equals(event.business)
      return not _.isUndefined(ownerMatch)  

  constructor : (@name) ->
    super(@name)  

  addPromotionRequest : (req, res, next)->
    if req.body
      console.log req.body
      if req.body._id
        console.log "here is an id"
      else
        target = new @promoRequest(req.body)
        target.save (err)=>
          if err
            console.log err
            next()
          else
            event = @model.findByIdAndUpdate req.params.id, {$push: {'promotionRequests': target}}, (er, doc)->
              if er
                console.log er
                res.send 400, er
              else
                console.log doc
                res.send 201
              next()
module.exports = new EventController()